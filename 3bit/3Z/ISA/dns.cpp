/*
  ============================================================================
   Projekt: DNS Resolver
   Autor: Taipova Evgeniya
   Login: xtaipo00
   Předmět: Síťové aplikace a správa sítí (ISA)
   Datum: 20.11.2023
  ============================================================================
*/

#include <vector>
#include <netdb.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sstream>
#include <cstring>
#include <iomanip>
#include "dns.h"

// Globální proměnné
Flags flags = {false, false, false, false, false, false, false, false};
unsigned int port = DEFAULT_PORT;
std::string server;
std::string address;

// Hlavní funkce programu
int main(int argc, char *argv[])
{
    // Kontrola počtu argumentů příkazové řádky
    if (argc < 4 || argc > 9)
    {
        fprintf(stderr, "Chyba: Nesprávný počet argumentů!\n");
        printHelp();
        return 1;
    }
    parseCommandLineArguments(argc, argv);
    performDNSServerCommunication();
    return 0;
}

// Funkce pro zpracování argumentů příkazové řádky
int parseCommandLineArguments(int argc, char **argv)
{
    // Iterace přes argumenty příkazové řádky
    for (int i = 1; i < argc; ++i)
    {
        const char *param = argv[i];
        const char *previousParam = (i > 1) ? argv[i - 1] : "";
        const char *nextParam = (i < argc - 1) ? argv[i + 1] : "";

        std::string paramStr(param);
        std::string previousParamStr(previousParam);
        std::string nextParamStr(nextParam);

        // Zpracování přepínače "-r"
        if (paramStr == "-r")
        {
            if (checkFlagRepetition(flags.recursion, "-r"))
                return 1;
            flags.recursion = true;
        }

        // Zpracování přepínače "-x"
        else if (paramStr == "-x")
        {
            if (checkFlagRepetition(flags.reverse, "-x"))
                return 1;
            flags.reverse = true;
        }

        // Zpracování přepínače "-6"
        else if (paramStr == "-6")
        {
            if (checkFlagRepetition(flags.six, "-6"))
                return 1;
            flags.six = true;
        }

        // Zpracování přepínače "-s" a adresy serveru
        else if (paramStr == "-s" && i < argc - 1)
        {
            if (checkArgument(nextParam, "-s"))
                return 1;
            if (checkFlagRepetition(flags.server, "-s"))
                return 1;
            flags.server = true;
            server = nextParam;
        }

        // Zpracování adresy serveru po přepínači "-s"
        else if (previousParamStr == "-s" && param[0] != '-' && flags.server)
            server = param;

        // Zpracování přepínače "-p" a čísla portu
        else if (paramStr == "-p" && i < argc - 1)
        {
            if (checkArgument(nextParam, "-p"))
                return 1;
            if (checkFlagRepetition(flags.port, "-p"))
                return 1;
            flags.port = true;
            if (!checkPort(nextParamStr))
            {
                fprintf(stderr, "Chyba: Neplatné číslo portu!");
                printHelp();
                return 1;
            }
            port = std::stoi(nextParam);
        }

        // Zpracování adresy po všech přepínačích
        else if (previousParamStr[0] != '-' && previousParamStr != "-s" && previousParamStr != "-p")
        {
            if (checkFlagRepetition(flags.address, "adresa"))
                return 1;
            flags.address = true;
            address = param;
        }
    }

    // Kontrola existence adresy a serveru
    if (!flags.address || !flags.server)
    {
        fprintf(stderr, "Chyba: Nezadána adresa nebo server!\n");
        printHelp();
        return 1;
    }

    // Kontrola vzájemného vyloučení přepínačů
    if (flags.reverse && flags.six)
    {
        fprintf(stderr, "Chyba: Přepínače -x a -6 jsou vzájemně vylučující!\n");
        printHelp();
        return 1;
    }

    return 0;
}

// Funkce pro výpis nápovědy
void printHelp()
{
    fprintf(stderr, "Použití: dns [-r] [-x] [-6] -s server [-p port] adresa\n");
    fprintf(stderr, "-r: Požadována rekurze (Recursion Desired = 1), jinak bez rekurze.\n");
    fprintf(stderr, "-x: Reverzní dotaz místo přímého.\n");
    fprintf(stderr, "-6: Dotaz typu AAAA místo výchozího A.\n");
    fprintf(stderr, "-s: IP adresa nebo doménové jméno serveru, kam se má zaslat dotaz.\n");
    fprintf(stderr, "-p port: Číslo portu, na který se má poslat dotaz, výchozí 53.\n");
    fprintf(stderr, "adresa: Dotazovaná adresa.\n");
    exit(1);
}

// Funkce pro kontrolu opakování přepínačů
bool checkFlagRepetition(bool flag, const char *flagName)
{
    if (flag)
    {
        fprintf(stderr, "Chyba: Opakované použití přepínače %s!\n", flagName);
        return true;
    }
    return false;
}

// Funkce pro kontrolu argumentu
bool checkArgument(const std::string &argument, const char *paramName)
{
    if (argument[0] == '\0' || argument[0] == '-')
    {
        fprintf(stderr, "Chyba: Přepínač %s má neplatný nebo chybějící argument!\n", paramName);
        return true;
    }
    return false;
}

// Funkce pro kontrolu čísla portu
bool checkPort(std::string portStr)
{
    size_t length = portStr.length();
    for (size_t i = 0; i < length; i++)
    {
        if (!std::isdigit(portStr[i]))
        {
            fprintf(stderr, "Chyba: Neplatný znak na pozici v čísle portu!\n");
            return false;
        }
    }
    int port = std::atoi(portStr.c_str());
    if (port < 1 || port > 65535)
    {
        fprintf(stderr, "Chyba: Neplatné číslo portu! Použijte port v rozsahu 1-65535.\n");
        return false;
    }
    return true;
}

// Funkce pro přípravu adresy pro DNS dotaz
void prepareAddressForDNS()
{
    std::string reversedAddress, finalReversedAddress;
    // Převrácení adresy
    for (auto it = address.crbegin(); it != address.crend(); ++it)
        reversedAddress += *it;
    reversedAddress += ".";

    // Přidání délek jednotlivých částí adresy do formátu DNS
    int count = 0;
    for (char &c : reversedAddress)
    {
        if (c != '.')
            count++;
        else
        {
            c = (char)count;
            count = 0;
        }
    }

    // Opětovné převrácení adresy do finální podoby
    for (auto it = reversedAddress.crbegin(); it != reversedAddress.crend(); ++it)
        finalReversedAddress += *it;
    address = finalReversedAddress;
}

// Funkce pro kontrolu typu adresy (IPv4 nebo IPv6) a zpracování reverzního dotazu
void checkIpv()
{
    // Určení typu adresy (IPv4 nebo IPv6)
    flags.ipv6 = (address.find(':') != std::string::npos);
    flags.ipv4 = !flags.ipv6;
}

// Funkce pro zpracování reverzního dotazu
void handleReverseQuery()
{
    // Kontrola typu adresy
    checkIpv();

    // Zpracování reverzního dotazu pro IPv6
    if (flags.ipv6 && address.find(".ip6.arpa") == std::string::npos)
        address = convertIPv6ToDNS(address);
    // Zpracování reverzního dotazu pro IPv4
    else if (!flags.ipv6 && address.find(".in-addr.arpa") == std::string::npos)
        address = convertIPv4ToDNS(address);
}

// Funkce pro odeslání DNS dotazu
void sendDNSQuery(int communicationSocket)
{
    // Vytvoření pole pro paketový buffer DNS dotazu
    std::array<unsigned char, MAX_PACKET_SIZE> packetBuffer{};

    // Sestavení hlavičky DNS dotazu
    populateDNSHeader(packetBuffer.data());

    // Sestavení dat otázky DNS dotazu
    populateDNSQuestionData(packetBuffer.data());

    // Odeslání DNS dotazu na server
    sendDNSPacket(communicationSocket, packetBuffer.data(), packetBuffer.size());
}

// Funkce pro provedení komunikace se DNS serverem
void performDNSServerCommunication()
{

    // Struktury pro informace o serveru
    struct addrinfo hints;
    struct addrinfo *serverInfo, *freeAddress;

    // Převedení čísla portu na řetězec
    std::string portStr = std::to_string(port);
    const char *portPtr = portStr.c_str();

    // Nastavení struktury hints pro získání informací o serveru
    memset(&hints, 0, sizeof(addrinfo));
    hints.ai_family = AF_UNSPEC;

    // Získání informací o serveru
    getServerInfo(hints, serverInfo, server.c_str(), portPtr);

    int communicationSocket;

    // Připojení se k první dostupné adrese serveru
    for (freeAddress = serverInfo; freeAddress != nullptr; freeAddress = freeAddress->ai_next)
    {
        // Vytvoření socketu pro komunikaci
        communicationSocket = socket(freeAddress->ai_family, SOCK_DGRAM, 0);
        if (communicationSocket == SEND_ERROR)
            continue;

        // Připojení k serveru
        connectToServer(communicationSocket, freeAddress);
        break;
    }

    // Pokud není dostupná žádná adresa, ukončí program s chybou
    if (freeAddress == nullptr)
    {
        fprintf(stderr, "Chyba: Nepodařilo se připojit.\n");
        exit(1);
    }

    // Odeslání DNS dotazu
    sendDNSQuery(communicationSocket);

    // Příjem a zpracování odpovědi od DNS serveru
    receiveAndProcessDNSAnswer(communicationSocket, freeAddress);
}

// Získání informací o serveru
void getServerInfo(const struct addrinfo &hints, struct addrinfo *&serverInfo, const char *server, const char *port)
{
    int getServerInfo = getaddrinfo(server, port, &hints, &serverInfo);
    if (getServerInfo != 0)
    {
        fprintf(stderr, "Chyba: Nepodařilo se získat informace o serveru!\n ");
        fprintf(stderr, "Získání IP adresy serveru selhalo.\n ");
        exit(1);
    }
}

// Připojení k serveru
void connectToServer(int &communicationSocket, struct addrinfo *freeAddress)
{
    if (communicationSocket == SEND_ERROR)
    {
        fprintf(stderr, "Chyba: Nepodařilo se vytvořit soket!\n");
        exit(1);
    }

    if (connect(communicationSocket, freeAddress->ai_addr, freeAddress->ai_addrlen) != 0)
    {
        fprintf(stderr, "Chyba: Nepodařilo se připojit k serveru!\n");
        close(communicationSocket);
        exit(1);
    }
}

// Odeslání DNS paketu
void sendDNSPacket(int communicationSocket, const unsigned char *packetBuffer, size_t packetSize)
{
    int sendOk = send(communicationSocket, packetBuffer, packetSize, 0);

    if (sendOk == SEND_ERROR)
    {
        fprintf(stderr, "Chyba: Odeslání požadavku selhalo!");
        exit(1);
    }
}

// Příjem DNS paketu
void receiveDNSPacket(int communicationSocket, unsigned char *answer, struct addrinfo *freeAddress)
{
    // Příjem odpovědi
    int answerOk = recvfrom(communicationSocket, answer, MAX_BUFFER_SIZE, 0, freeAddress->ai_addr, (socklen_t *)&(freeAddress->ai_addrlen));

    if (answerOk == SEND_ERROR)
    {
        fprintf(stderr, "Chyba: Nepodařilo se získat požadovanou odpověď!\n");
        exit(1);
    }

    close(communicationSocket);
    freeaddrinfo(freeAddress);
}

// Zpracování a výpis DNS odpovědi
void processAndPrintDNSAnswer(const unsigned char *answer)
{
    struct DNSHeader *header = (struct DNSHeader *)answer;
    printf("Authoritative: %s, Recursive: %s, Truncated: %s\n",
           (ntohs(header->flags) & 0x400) > FLAGS_DEFAULT ? "Yes" : "No",
           (flags.recursion && (ntohs(header->flags) & 0x80) > FLAGS_DEFAULT) ? "Yes" : "No",
           (ntohs(header->flags) & TRUNCATION_FLAG_MASK) > FLAGS_DEFAULT ? "Yes" : "No");

    char *position = (char *)header + sizeof(DNSHeader);

    if (ntohs(header->qdcount) < 0x0001)
    {
        fprintf(stderr, "Chyba: Obdrženo nula dotazů!\n");
        exit(1);
    }

    printf("Question section (%d)\n", ntohs(header->qdcount));
    for (int i = 0; i < ntohs(header->qdcount); ++i)
    {
        struct DNSRequest request;
        printf("  %s, ", parseDomainName((unsigned char **)&position, (void *)header).c_str());
        std::copy(position, position + sizeof(DNSRequest), reinterpret_cast<char *>(&request));
        printf("  %s, %s\n", dnsTypeToString(ntohs(request.qtype)).c_str(), dnsClassToString(ntohs(request.qclass)).c_str());
        position += sizeof(DNSRequest);
    }

    printf("Answer section (%d)\n", ntohs(header->ancount));
    for (int i = 0; i < ntohs(header->ancount); i++)
    {
        printf("  %s\n", formatDNSAnswer(header, (unsigned char **)&position).c_str());
    }

    printf("Authority section (%d)\n", ntohs(header->nscount));
    for (int i = 0; i < ntohs(header->nscount); i++)
    {
        printf("  %s\n", formatDNSAnswer(header, (unsigned char **)&position).c_str());
    }

    printf("Additional section (%d)\n", ntohs(header->arcount));
    for (int i = 0; i < ntohs(header->arcount); i++)
    {
        printf("  %s\n", formatDNSAnswer(header, (unsigned char **)&position).c_str());
    }
}

// Formátování DNS odpovědi
std::string formatDNSAnswer(void *header, unsigned char **position)
{
    DNSResponse dnsResponse = {0, 0, 0, 0};
    std::ostringstream result;

    // Formátování DNS jména a přidání k výsledku
    result << parseDomainName(position, header) << ", ";

    // Kopírování dat přímo do struktury
    std::copy(*position, *position + sizeof(DNSResponse), reinterpret_cast<unsigned char *>(&dnsResponse));
    *position += sizeof(DNSResponse);

    // Přidání typu, třídy a TTL k výsledku
    result << dnsTypeToString(ntohs(dnsResponse.type)) << ", "
           << dnsClassToString(ntohs(dnsResponse.cls)) << ", "
           << std::to_string(ntohl(dnsResponse.ttl)) << ", ";

    // Zpracování RDATA a přidání k výsledku
    result << parseRdata(ntohs(dnsResponse.type), *position, header);

    // Posunutí pozice o délku RDATA
    *position += ntohs(dnsResponse.rdlength);

    // Převod std::ostringstream na std::string
    return result.str();
}

// Zpracování RDATA podle typu
std::string parseRdata(uint16_t type, unsigned char *position, void *header)
{
    switch (type)
    {
    case DNS_TYPE_A:
        char ipv4Address[INET_ADDRSTRLEN];
        inet_ntop(AF_INET, position, ipv4Address, INET_ADDRSTRLEN);
        return ipv4Address;

    case DNS_TYPE_NS:
    case DNS_TYPE_CNAME:
    case DNS_TYPE_PTR:
        return parseDomainName((unsigned char **)&position, (void *)header);

    case DNS_TYPE_SOA:
        return parseRdataSoa(&position, header);

    case DNS_TYPE_AAAA:
        char ipv6Address[INET6_ADDRSTRLEN];
        inet_ntop(AF_INET6, position, ipv6Address, INET6_ADDRSTRLEN);
        return ipv6Address;

    default:
        return "unknown";
    }
}

// Zpracování RDATA pro typ SOA
std::string parseRdataSoa(unsigned char **position, void *header)
{
    struct RDATA_SOA
    {
        uint32_t serial;
        int32_t refresh;
        int32_t retry;
        uint32_t expire;
        uint32_t minimum;
    };

    RDATA_SOA soa = {0, 0, 0, 0, 0};
    std::string soaStruct;

    soaStruct = parseDomainName(reinterpret_cast<unsigned char **>(position), header) + " ";  // mname
    soaStruct += parseDomainName(reinterpret_cast<unsigned char **>(position), header) + " "; // rname

    // Kopírování binárních dat do struktury
    std::memcpy(&soa, *position, sizeof(RDATA_SOA));
    soaStruct += std::to_string(ntohl(soa.serial)) + " " + std::to_string(ntohl(soa.refresh)) + " " + std::to_string(ntohl(soa.retry)) + " " + std::to_string(ntohl(soa.expire)) + " " + std::to_string(ntohl(soa.minimum));
    return soaStruct;
}

// Konverze IPv4 na formát DNS
std::string convertIPv4ToDNS(std::string ip)
{
    std::string reversed;
    std::string octet;

    for (char ch : ip)
    {
        if (ch == '.')
        {
            reversed = octet + '.' + reversed;
            octet.clear();
        }
        else
            octet += ch;
    }

    reversed = octet + '.' + reversed;

    return reversed + "in-addr.arpa.";
}

// Konverze IPv6 na formát DNS
std::string convertIPv6ToDNS(std::string ip)
{
    struct in6_addr binary;
    if (inet_pton(AF_INET6, ip.c_str(), &binary) != 1)
    {
        // Zpracování neplatné IPv6 adresy.
        return "invalid-ip6.arpa.";
    }

    // Konverze binární adresy na hexadecimální řetězec
    std::stringstream hexStream;
    hexStream << std::hex << std::setfill('0');
    for (int i = 0; i < 16; ++i)
    {
        hexStream << std::setw(2) << static_cast<int>(binary.s6_addr[i]);
    }

    std::string hexAddress = hexStream.str();

    // Obrácení hexadecimální adresy a přidání teček
    std::string reversedAddress;
    for (auto it = hexAddress.rbegin(); it != hexAddress.rend(); ++it)
    {
        if (*it != ':')
        {
            reversedAddress.push_back(*it);
            reversedAddress.push_back('.');
        }
    }

    return reversedAddress + "ip6.arpa.";
}

// Zpracování DNS jména
std::string parseDomainName(unsigned char **currentPosition, void *baseAddress)
{
    std::string parsedName;

    while (**currentPosition != 0)
    {
        uint16_t labelLength = ntohs((**currentPosition << 8) | *(*currentPosition + 1));
        std::vector<unsigned char> label(2);
        *reinterpret_cast<uint16_t *>(label.data()) = labelLength;

        if ((label[0] & OFFSET_MASK) == OFFSET_MASK)
        {
            uint16_t offset = ((label[0] << 8) | label[1]) & OFFSET_MASK_VALUE;
            unsigned char *labelPosition = (unsigned char *)baseAddress + offset;
            parsedName += parseDomainName(&labelPosition, baseAddress);
            (*currentPosition)++;
            break;
        }
        else
        {
            for (int i = 0; i < label[0]; ++i)
                parsedName += (*currentPosition)[1 + i];
            parsedName += '.';

            *currentPosition += label[0] + 1;
        }
    }
    (*currentPosition)++;

    return parsedName;
}

// Převod DNS typu na řetězec
std::string dnsTypeToString(uint16_t type)
{
    switch (type)
    {
    case DNS_TYPE_A:
        return "A";
    case DNS_TYPE_NS:
        return "NS";
    case DNS_TYPE_CNAME:
        return "CNAME";
    case DNS_TYPE_SOA:
        return "SOA";
    case DNS_TYPE_PTR:
        return "PTR";
    case DNS_TYPE_AAAA:
        return "AAAA";
    default:
        return "neznámý";
    }
}

// Převod DNS třídy na řetězec
std::string dnsClassToString(uint16_t cls)
{
    switch (cls)
    {
    case IN:
        return "IN";
    case CS:
        return "CS";
    case CH:
        return "CH";
    case HS:
        return "HS";
    default:
        return "unknown";
    }
}

// Funkce pro sestavení hlavičky DNS v paketovém bufferu.
void populateDNSHeader(unsigned char *packetBuffer)
{
    // Přetypování ukazatele na strukturu DNSHeader pro pohodlnější manipulaci
    struct DNSHeader *header = reinterpret_cast<struct DNSHeader *>(packetBuffer);

    // Nastavení identifikátoru zprávy na ID procesu
    header->id = htons(static_cast<uint16_t>(getpid()));

    // Nastavení hodnoty vlajek v hlavičce DNS
    uint16_t flagsValue = FLAGS_DEFAULT;
    flagsValue |= (flags.recursion ? RECURSION_FLAG_MASK : 0);
    header->flags = htons(flagsValue);

    // Nastavení počtu otázek v DNS zprávě na 1
    header->qdcount = htons(1);

    // Nastavení počtu záznamů v sekcích na 0
    header->ancount = 0;
    header->nscount = 0;
    header->arcount = 0;

    // Zpracování zpětného dotazu (reverse query), pokud je aktivní
    if (flags.reverse)
        handleReverseQuery();
}

// Funkce pro sestavení dat otázky DNS v paketovém bufferu.
void populateDNSQuestionData(unsigned char *packetBuffer)
{
    // Získání pozice pro vložení dat otázky do paketového bufferu
    char *position = (char *)packetBuffer + sizeof(DNSHeader);

    // Pokud adresa nekončí tečkou, přidejte ji
    if (address.back() != '.')
        address = address + '.';

    // Formátování adresy do formátu DNS
    prepareAddressForDNS();

    // Kopírování formátované adresy do paketového bufferu
    if (address.length() > (sizeof(packetBuffer) - sizeof(DNSHeader) - sizeof(DNSRequest)))
    {
        fprintf(stderr, "Chyba: Otázka DNS je příliš dlouhá\n");
        exit(1);
    }
    strcpy(position, address.c_str());

    // Posunutí pozice na strukturu DNSRequest
    struct DNSRequest *dnsquestion = (struct DNSRequest *)(position + address.length());

    // Nastavení typu a třídy DNS dotazu
    dnsquestion->qtype = htons(flags.six ? DNS_TYPE_AAAA : DNS_TYPE_A);
    if (flags.reverse)
        dnsquestion->qtype = htons(DNS_TYPE_PTR);

    dnsquestion->qclass = htons(IN);
}

// Funkce pro příjem a zpracování odpovědi DNS.
void receiveAndProcessDNSAnswer(int communicationSocket, struct addrinfo *freeAddress)
{
    // Vytvoření vektoru pro uložení odpovědi od DNS serveru
    std::vector<unsigned char> answer(MAX_BUFFER_SIZE, 0);
    receiveDNSPacket(communicationSocket, answer.data(), freeAddress);

    // Vytvoření vektoru pro paketový buffer
    std::vector<unsigned char> packetBuffer(MAX_PACKET_SIZE, 0);
    processAndPrintDNSAnswer(answer.data());
}
