#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <unistd.h>    // for fork(), usleep(), getpid()
#include <sys/wait.h>  // for wait()
#include <semaphore.h> // for working with semaphores
#include <fcntl.h>     // for O_CREAT and O_EXCL
#include <sys/shm.h>   // for working with shared memory
#include <time.h>      //for time()
#include <ctype.h>     // for isdigit()

//-----------------------------------------STRUCTURES-----------------------------------------

// structure for input arguments
typedef struct args
{
    int NO, NH, TI, TB;
} programArgs;

// structure for memory and work in processes
typedef struct mem
{
    int actionCount;
    int oxygen;
    int hydrogen;
    int barCount;
    int molCount;
} shMemory;

// structure for semaphores
typedef struct sem
{
    sem_t *semOut;
    sem_t *semMutex;
    sem_t *oQueue;
    sem_t *hQueue;
    sem_t *barMutex;
    sem_t *bar1;
    sem_t *bar2;
} Semaphore;

//-----------------------------------------FUNCTIONS-----------------------------------------

// functions to control arguments
bool isNumber(char number[]);
bool controlArguments(int argc, char *argv[], programArgs *args);

// shared memory functions
key_t memory_key(Semaphore *semaphore, FILE *file_out);
int memory_id(key_t key, Semaphore *semaphore, FILE *file_out);
void memory_c(int shmid, shMemory *memory);

// semaphore functions
bool semaphore_init(Semaphore *semaphore);
void semafore_close(Semaphore *semaphore);
void semaphore_end(Semaphore *semaphore, FILE *file);

// oxygen
void oxygen_process(programArgs *args, Semaphore *semaphore, shMemory *memory, FILE *file);

// hydrogen
void hydrogen_process(programArgs *args, Semaphore *semaphore, shMemory *memory, FILE *file);

//-----------------------------------------MAIN PROCESS-----------------------------------------

int main(int argc, char *argv[])
{
    programArgs args;
    FILE *file_out;
    Semaphore semaphore;
    shMemory *memory;
    pid_t pid_ox, pid_hyd;

    if (controlArguments(argc, argv, &args) == 1)
        return 1;

    // creating output file
    if ((file_out = fopen("proj2.out", "w")) == NULL)
    {
        fprintf(stderr, "Error in out file\n");
        return 1;
    }
    // controls buffering for stream(file_out)
    setbuf(file_out, NULL);

    if (semaphore_init(&semaphore) == 1)
    {
        fprintf(stderr, "Error in inizialization of semaphore\n");
        return 1;
    }

    key_t key = memory_key(&semaphore, file_out);
    int shmid = memory_id(key, &semaphore, file_out);

    // attach the given memory
    memory = shmat(shmid, NULL, 0);
    if (memory == (void *)-1)
    {
        semaphore_end(&semaphore, file_out);
        memory_c(shmid, NULL);
        fprintf(stderr, "Error in shmat\n");
        return 1;
    }
    memory->actionCount = 0;
    memory->oxygen = 0;
    memory->hydrogen = 0;
    memory->barCount = 0;
    memory->molCount = 1;

    // main process
    pid_ox = fork();
    if (pid_ox == 0)
    {
        oxygen_process(&args, &semaphore, memory, file_out);
        semafore_close(&semaphore);
        exit(0);
    }
    else if (pid_ox > 0)
    {
        pid_hyd = fork();
        if (pid_hyd == 0)
        {
            hydrogen_process(&args, &semaphore, memory, file_out);
            semafore_close(&semaphore);
            exit(0);
        }
        wait(NULL);
    }
    else
    {
        fprintf(stderr, "Error in main process.\n");
    }

    memory_c(shmid, memory);
    semaphore_end(&semaphore, file_out);
    return 0;
}

bool isNumber(char number[])
{
    int i = 0;
    // checking for negative numbers
    if (number[0] == '-')
        i = 1;
    for (; number[i] != 0; i++)
    {
        // if (number[i] > '9' || number[i] < '0')
        if (!isdigit(number[i]))
            return false;
    }
    return true;
}

bool controlArguments(int argc, char *argv[], programArgs *args)
{
    for (int i = 1; i < argc; i++)
    {
        if (!(isNumber(argv[i]) == true))
        {
            fprintf(stderr, "Wrong argument №%d\n", i);
            return 1;
        }
    }
    if (argc == 5)
    {
        if (atoi(argv[1]) < 0)
        {
            fprintf(stderr, "NO must be bigger than 0\n");
            return 1;
        }
        if (atoi(argv[2]) < 0)
        {
            fprintf(stderr, "NH must be bigger than 0\n");
            return 1;
        }
        if ((atoi(argv[3]) < 0) || (atoi(argv[3]) > 1000))
        {
            fprintf(stderr, "TI must be between 0 and 1000\n");
            return 1;
        }
        if ((atoi(argv[4]) < 0) || (atoi(argv[4]) > 1000))
        {
            fprintf(stderr, "TB must be between 0 and 1000\n");
            return 1;
        }
    }
    else
    {
        fprintf(stderr, "Wrong number of arguments\n");
        return 1;
    }

    args->NO = atoi(argv[1]);
    args->NH = atoi(argv[2]);
    args->TI = atoi(argv[3]);
    args->TB = atoi(argv[4]);

    return 0;
}
bool semaphore_init(Semaphore *semaphore)
{
    // sem_open initializes and opens a named semaphore
    // semaphore is identified by name ("/xtaipo00_...")
    // O_CREAT | O_EXCL - an error is returned if a semaphore with the given name already exists
    // sem_open() returns the address of the new semaphore, which is used when calling other semaphore-related functions
    // on error, sem_open() returns SEM_FAILED
    if ((semaphore->semOut = sem_open("/xtaipo00_semOut", O_CREAT | O_EXCL, 0666, 1)) == SEM_FAILED)
        return 1;
    if ((semaphore->hQueue = sem_open("/xtaipo00_hQueue", O_CREAT | O_EXCL, 0666, 0)) == SEM_FAILED)
        return 1;
    if ((semaphore->oQueue = sem_open("/xtaipo00_oQueue", O_CREAT | O_EXCL, 0666, 0)) == SEM_FAILED)
        return 1;
    if ((semaphore->semMutex = sem_open("/xtaipo00_semMutex", O_CREAT | O_EXCL, 0666, 1)) == SEM_FAILED)
        return 1;
    if ((semaphore->barMutex = sem_open("/xtaipo00_barMutex", O_CREAT | O_EXCL, 0666, 1)) == SEM_FAILED)
        return 1;
    if ((semaphore->bar1 = sem_open("/xtaipo00_bar1", O_CREAT | O_EXCL, 0666, 0)) == SEM_FAILED)
        return 1;
    if ((semaphore->bar2 = sem_open("/xtaipo00_bar2", O_CREAT | O_EXCL, 0666, 1)) == SEM_FAILED)
        return 1;
    return 0;
}

void semafore_close(Semaphore *semaphore)
{
    // sem_close closes a named semaphore
    // returns 0 on succes and -1 on error
    sem_close(semaphore->semOut);
    sem_close(semaphore->hQueue);
    sem_close(semaphore->oQueue);
    sem_close(semaphore->semMutex);
    sem_close(semaphore->barMutex);
    sem_close(semaphore->bar1);
    sem_close(semaphore->bar2);
}

void oxygen_process(programArgs *args, Semaphore *semaphore, shMemory *memory, FILE *file)
{
    srand(time(NULL) * getpid());
    pid_t ox_fork;
    for (int i = 0; i < args->NO; i++)
    {
        usleep(1000 * (rand() % (args->TI + 1)));
        ox_fork = fork();
        if (ox_fork == 0)
        {
            sem_wait(semaphore->semOut);
            fprintf(file, "%d: O %d: started\n", ++(memory->actionCount), ++i);
            fflush(file);
            sem_post(semaphore->semOut);

            sem_wait(semaphore->semMutex); // 1. MUTEX.WAIT()

            memory->oxygen = memory->oxygen + 1; // 2. OXYGEN ++
            if (memory->hydrogen >= 2)           // 3. IF H >= 2
            {
                sem_wait(semaphore->semOut);
                fprintf(file, "%d: O %d: going to queue\n", ++(memory->actionCount), i);
                fflush(NULL);
                sem_post(semaphore->semOut);

                sem_post(semaphore->hQueue); // 4. HQUEUE.SIGNAL(2)
                sem_post(semaphore->hQueue);

                memory->hydrogen = memory->hydrogen - 2; // 5. H -- 2

                sem_post(semaphore->oQueue);         // 6. OQUEUE.SIGNAL()
                memory->oxygen = memory->oxygen - 1; // 7. O -- 1
            }
            else // 8. ELSE
            {
                sem_wait(semaphore->semOut);
                fprintf(file, "%d: O %d: going to queue\n", ++(memory->actionCount), i);
                fflush(NULL);
                sem_post(semaphore->semOut);

                sem_post(semaphore->semMutex); // 9. MUTEX.SIGNAL()
            }

            sem_wait(semaphore->oQueue); // 10. OQUEUE.WAIT()

            /*if (memory->hydrogen < 1)
                       {
                           sem_wait(semaphore->semOut);
                           fprintf(file, "%d: O %d: not enough H \n", ++(memory->actionCount), i);
                           fflush(NULL);
                           sem_post(semaphore->semOut);
                       }*/

            sem_wait(semaphore->semOut);
            fprintf(file, "%d: O %d: creating molecule %d \n", ++(memory->actionCount), i, memory->molCount);
            fflush(NULL);
            sem_post(semaphore->semOut);

            // molucules creation time
            usleep(1000 * (rand() % (args->TB + 1)));

            // barrier
            sem_wait(semaphore->barMutex);
            memory->barCount = memory->barCount + 1;
            if (memory->barCount == 3)
            {
                sem_wait(semaphore->bar2);
                sem_post(semaphore->bar1);
            }
            sem_post(semaphore->barMutex);
            sem_wait(semaphore->bar1);
            sem_post(semaphore->bar1);

            sem_wait(semaphore->semOut);
            fprintf(file, "%d: O %d: molecule %d created\n", ++memory->actionCount, i, memory->molCount);
            fflush(NULL);
            sem_post(semaphore->semOut);

            sem_wait(semaphore->barMutex);
            memory->barCount = memory->barCount - 1;
            if (memory->barCount == 0)
            {
                sem_wait(semaphore->bar1);
                sem_post(semaphore->bar2);
            }
            sem_post(semaphore->barMutex);
            sem_wait(semaphore->bar2);
            sem_post(semaphore->bar2);

            sem_post(semaphore->semMutex);
            semafore_close(semaphore);
            memory->molCount++;
            exit(0);
        }
        else if (ox_fork < 0)
        {
            fprintf(stderr, "Error in oxygen process");
        }
    }
    wait(NULL);
}
void hydrogen_process(programArgs *args, Semaphore *semaphore, shMemory *memory, FILE *file)
{
    srand(time(NULL) * getpid());
    pid_t hydr_fork;
    for (int i = 0; i < args->NH; i++)
    {
        usleep(1000 * (rand() % (args->TI + 1)));
        hydr_fork = fork();
        if (hydr_fork == 0)
        {
            sem_wait(semaphore->semOut);
            fprintf(file, "%d: H %d: started\n", ++(memory->actionCount), ++i);
            fflush(file);
            sem_post(semaphore->semOut);
            sem_wait(semaphore->semMutex);

            memory->hydrogen = memory->hydrogen + 1;
            if (memory->hydrogen >= 2 && memory->oxygen >= 1)
            {
                sem_wait(semaphore->semOut);
                fprintf(file, "%d: H %d: going to queue\n", ++(memory->actionCount), i);
                fflush(NULL);
                sem_post(semaphore->semOut);
                sem_post(semaphore->oQueue);
                memory->oxygen = memory->oxygen - 1;
                sem_post(semaphore->hQueue);
                sem_post(semaphore->hQueue);
                memory->hydrogen = memory->hydrogen - 2;
            }
            else
            {
                sem_wait(semaphore->semOut);
                fprintf(file, "%d: H %d: going to queue\n", ++(memory->actionCount), i);
                fflush(NULL);
                sem_post(semaphore->semOut);
                sem_post(semaphore->semMutex);
            }

            /* if (memory->oxygen < 0)
             {
                 sem_wait(semaphore->semOut);
                 fprintf(file, "%d: H %d: not enough O or H \n", ++(memory->actionCount), i);
                 fflush(NULL);
                 sem_post(semaphore->semOut);
             }*/

            sem_wait(semaphore->hQueue); // 10. HQUEUE.WAIT()

            sem_wait(semaphore->semOut);
            fprintf(file, "%d: H %d: creating molecule %d \n", ++(memory->actionCount), i, memory->molCount);
            fflush(NULL);
            sem_post(semaphore->semOut);
            usleep(1000 * (rand() % (args->TB + 1)));

            sem_wait(semaphore->barMutex);
            memory->barCount = memory->barCount + 1;
            if (memory->barCount == 3)
            {
                sem_wait(semaphore->bar2);
                sem_post(semaphore->bar1);
            }
            sem_post(semaphore->barMutex);
            sem_wait(semaphore->bar1);
            sem_post(semaphore->bar1);

            sem_wait(semaphore->semOut);
            fprintf(file, "%d: H %d: molecule %d created\n", ++memory->actionCount, i, memory->molCount);
            fflush(NULL);
            sem_post(semaphore->semOut);

            sem_wait(semaphore->barMutex);
            memory->barCount = memory->barCount - 1;
            if (memory->barCount == 0)
            {
                sem_wait(semaphore->bar1);
                sem_post(semaphore->bar2);
            }
            sem_post(semaphore->barMutex);
            sem_wait(semaphore->bar2);
            sem_post(semaphore->bar2);

            semafore_close(semaphore);

            exit(0);
        }
        else if (hydr_fork < 0)
        {
            fprintf(stderr, "Error in hydrogen process");
        }
    }
    wait(NULL);
}

void semaphore_end(Semaphore *semaphore, FILE *file)
{
    semafore_close(semaphore);
    // sem_unlink removes a named semaphore
    sem_unlink("/xtaipo00_semOut");
    sem_unlink("/xtaipo00_hQueue");
    sem_unlink("/xtaipo00_oQueue");
    sem_unlink("/xtaipo00_semMutex");
    sem_unlink("/xtaipo00_barMutex");
    sem_unlink("/xtaipo00_bar1");
    sem_unlink("/xtaipo00_bar2");
    fclose(file);
}

key_t memory_key(Semaphore *semaphore, FILE *file_out)
{
    // return a key based on path("proj2") and id(1) that is usable in call to shmget()
    //  On error ftok() returns -1
    key_t key = ftok("proj2", 1);
    if (key == -1)
    {
        semaphore_end(semaphore, file_out);
        fprintf(stderr, "Error in ftok");
        return 1;
    }
    return key;
}

// returns the identifier of the shared memory
int memory_id(key_t key, Semaphore *semaphore, FILE *file_out)
{
    int shmid = shmget(key, sizeof(shMemory), IPC_CREAT | 0666);
    // shmid returns -1 if error
    if (shmid == -1)
    {
        semaphore_end(semaphore, file_out);
        fprintf(stderr, "Error in shmget");
        return 1;
    }
    return shmid;
}

void memory_c(int shmid, shMemory *memory)
{
    // shmdt is used to detach a shared memory
    if (shmdt(memory) == -1)
        fprintf(stderr, "Error in shmdt\n");
    // shmctl removes a shared memory
    if (shmctl(shmid, IPC_RMID, NULL) == -1)
        fprintf(stderr, "Error in shmctl\n");
}
