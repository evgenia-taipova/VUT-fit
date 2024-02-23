#include <stdio.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>

void control_port(int argc, char const *argv[]);

void get_hostname(char *http, int new_socket);
void get_cpu_name(char *http, int new_socket);
void get_load(char *http, int new_socket);

void control_request(int new_socket, char buffer[]);

int main(int argc, char const *argv[])
{
    control_port(argc, argv);
    int port = atoi(argv[1]);

    int server_fd, new_socket;
    long valread;

    char buffer[128] = {0};
    char message[1024] = {0};

    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0)
    {
        fprintf(stderr, "You have an error in socket\n");
        exit(EXIT_FAILURE);
    }

    struct sockaddr_in address;

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(port);

    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &(int){1}, sizeof(int)) < 0)
    {
        fprintf(stderr, "You have an error in setsockopt\n");
        exit(EXIT_FAILURE);
    }

    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0)
    {
        fprintf(stderr, "You have an error in bind\n");
        exit(EXIT_FAILURE);
    }

    if (listen(server_fd, 10) < 0)
    {
        fprintf(stderr, "You have an error in set socket opt\n");
        exit(EXIT_FAILURE);
    }

    while (1)
    {
        if ((new_socket = accept(server_fd, NULL, NULL)) < 0)
        {
            fprintf(stderr, "Error in set socket opt\n");
            exit(EXIT_FAILURE);
        }

        valread = read(new_socket, buffer, 128);

        control_request(new_socket, buffer);

        close(new_socket);
    }
    return 0;
}

void control_port(int argc, char const *argv[])
{
    if (argc != 2)
    {
        fprintf(stderr, "Wrong count of params, you need enter only one - port number\n");
        exit(EXIT_FAILURE);
    }
}

void get_hostname(char *http, int new_socket)
{
    FILE *info;
    char answer_host[512];
    info = popen("cat /proc/sys/kernel/hostname", "r");
    fgets(answer_host, 512, info);
    fclose(info);
    write(new_socket, http, strlen(http));
    write(new_socket, answer_host, strlen(answer_host));
}
void get_cpu_name(char *http, int new_socket)
{
    FILE *info;
    char answer_cpu[512];
    info = popen("lscpu | grep 'Model name' | cut -f 2 -d ':' |awk '{$1=$1}1' ", "r");
    fgets(answer_cpu, 512, info);
    fclose(info);
    write(new_socket, http, strlen(http));
    write(new_socket, answer_cpu, strlen(answer_cpu));
}

void get_load(char *http, int new_socket)
{
    long long int previdle, prevnonidle;
    long long int nonidle, idle;
    long long int total, prevtotal;
    long long int totald, idled;
    long long int a[7];
    FILE *fp = fopen("/proc/stat", "r");
    fscanf(fp, "%*s %lld %lld %lld %lld %lld %lld %lld %lld", &a[0], &a[1], &a[2], &a[3], &a[4], &a[5], &a[6], &a[7]);
    fclose(fp);
    prevnonidle = a[0] + a[1] + a[2] + a[5] + a[6] + a[7];
    previdle = a[3] + a[4];
    prevtotal = previdle + prevnonidle;
    sleep(1);
    FILE *pf = fopen("/proc/stat", "r");
    fscanf(fp, "%*s %lld %lld %lld %lld %lld %lld %lld %lld", &a[0], &a[1], &a[2], &a[3], &a[4], &a[5], &a[6], &a[7]);
    fclose(pf);
    nonidle = a[0] + a[1] + a[2] + a[5] + a[6] + a[7];
    idle = a[3] + a[4];
    total = idle + nonidle;
    totald = total - prevtotal;
    idled = idle - previdle;
    int CPU_Percentage = 100 * (totald - idled) / totald;
    char cpu_load_char[4] = {0};
    sprintf(cpu_load_char, "%d%%\n", CPU_Percentage);
    write(new_socket, http, strlen(http));
    write(new_socket, cpu_load_char, strlen(cpu_load_char));
}

void control_request(int new_socket, char buffer[])
{
    char *http = "HTTP/1.1 200 OK\nContent-Type : text/plain\r\n\r\n";
    char *wrong = "HTTP/1.1 200 OK\nContent-Type: text/plain\n\n400 Not Found\n";
    char host_str[] = "GET /hostname";
    char cpu_str[] = "GET /cpu-name";
    char load_str[] = "GET /load";

    if (strncmp(buffer, host_str, 13) == 0)
    {
        get_hostname(http, new_socket);
    }
    else if (strncmp(buffer, cpu_str, 13) == 0)
    {
        get_cpu_name(http, new_socket);
    }
    else if (strncmp(buffer, load_str, 9) == 0)
    {
        get_load(http, new_socket);
    }
    else
    {
        write(new_socket, wrong, strlen(wrong));
    }
}