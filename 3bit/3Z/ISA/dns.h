/*
  ============================================================================
   Projekt: DNS Resolver
   Autor: Taipova Evgeniya
   Login: xtaipo00
   Předmět: Síťové aplikace a správa sítí (ISA)
   Datum: 20.11.2023
  ============================================================================
*/

#ifndef DNS_FUNCTIONS_H
#define DNS_FUNCTIONS_H

#include <string>

// Konstanty pro velikosti bufferu a paketu
const int MAX_BUFFER_SIZE = 1472;
const int MAX_PACKET_SIZE = 512;

// Výchozí hodnota pro port
const int DEFAULT_PORT = 53;

// Konstanta pro chybu při odesílání
const int SEND_ERROR = -1;

// Masky pro práci s vlajkami
const int RECURSION_FLAG_MASK = 0x1 << 8;
const int TRUNCATION_FLAG_MASK = 0x200;
const int FLAGS_DEFAULT = 0x0;

// Konstanty pro offset v DNS odpovědi
const uint16_t OFFSET_MASK = 0xC0;
const uint16_t OFFSET_MASK_VALUE = 0x3FFF;

// Enumy pro typy DNS dotazů a třídy
enum DnsType
{
    DNS_TYPE_A = 1,
    DNS_TYPE_NS = 2,
    DNS_TYPE_CNAME = 5,
    DNS_TYPE_SOA = 6,
    DNS_TYPE_PTR = 12,
    DNS_TYPE_AAAA = 28,
};

enum DNSClass
{
    IN = 1,
    CS = 2,
    CH = 3,
    HS = 4
};

// Struktura pro uchování stavu vlajek
struct Flags
{
    bool recursion;
    bool reverse;
    bool six;
    bool port;
    bool server;
    bool address;
    bool ipv4;
    bool ipv6;
};

// Struktury pro hlavičku, dotaz a odpověď DNS
struct DNSHeader
{
    uint16_t id;
    uint16_t flags;
    uint16_t qdcount;
    uint16_t ancount;
    uint16_t nscount;
    uint16_t arcount;
};

struct DNSRequest
{
    uint16_t qtype;
    uint16_t qclass;
};

struct DNSResponse
{
    uint16_t type;
    uint16_t cls;
    uint32_t ttl;
    uint16_t rdlength;
} __attribute((packed));

// =====================
// Argumenty příkazové řádky
// =====================

// Funkce pro zpracování argumentů příkazové řádky
int parseCommandLineArguments(int argc, char **argv);

// Funkce pro výpis nápovědy
void printHelp();

// Funkce pro kontrolu opakování vlajky
bool checkFlagRepetition(bool flag, const char *flagName);

// Funkce pro kontrolu argumentu
bool checkArgument(const std::string &argument, const char *paramName);

// Funkce pro kontrolu platnosti portu
bool checkPort(std::string portStr);

// =====================
// Příprava DNS dotazu
// =====================

// Funkce pro přípravu adresy pro DNS dotaz
void prepareAddressForDNS();

// Funkce pro kontrolu typu adresy (IPv4 nebo IPv6)
void checkIpv();

// Funkce pro zpracování reverzního dotazu
void handleReverseQuery();

// Funkce pro odeslání DNS dotazu
void sendDNSQuery(int communicationSocket);

// =====================
// Komunikace se DNS serverem
// =====================

// Funkce pro provedení komunikace se DNS serverem
void performDNSServerCommunication();

// Funkce pro získání informací o serveru
void getServerInfo(const struct addrinfo &hints, struct addrinfo *&serverInfo, const char *server, const char *port);

// Funkce pro připojení k serveru
void connectToServer(int &communicationSocket, struct addrinfo *freeAddress);

// Funkce pro odeslání DNS packetu
void sendDNSPacket(int communicationSocket, const unsigned char *packetBuffer, size_t packetSize);

// Funkce pro příjem DNS odpovědi
void receiveDNSPacket(int communicationSocket, unsigned char *answer, struct addrinfo *freeAddress);

// Funkce pro zpracování a výpis DNS odpovědi
void processAndPrintDNSAnswer(const unsigned char *answer);

// =====================
// Zpracování DNS odpovědi
// =====================

// Funkce pro formátování DNS odpovědi
std::string formatDNSAnswer(void *header, unsigned char **position);

// Funkce pro zpracování RDATA
std::string parseRdata(uint16_t type, unsigned char *position, void *header);

// Funkce pro zpracování RDATA typu SOA
std::string parseRdataSoa(unsigned char **position, void *header);

// =====================
// Konverze a parsování
// =====================

// Funkce pro konverzi IPv4 adresy na formát pro DNS dotaz
std::string convertIPv4ToDNS(std::string ip);

// Funkce pro konverzi IPv6 adresy na formát pro DNS dotaz
std::string convertIPv6ToDNS(std::string ip);

// Funkce pro parsování doménového jména
std::string parseDomainName(unsigned char **currentPosition, void *baseAddress);

// =====================
// Pomocné funkce
// =====================

// Funkce pro převod typu DNS na řetězec
std::string dnsTypeToString(uint16_t type);

// Funkce pro převod třídy DNS na řetězec
std::string dnsClassToString(uint16_t cls);

// Funkce pro naplnění hlavičky DNS dotazu
void populateDNSHeader(unsigned char *packetBuffer);

// Funkce pro naplnění dat DNS dotazu
void populateDNSQuestionData(unsigned char *packetBuffer);

// Funkce pro příjem a zpracování DNS odpovědi
void receiveAndProcessDNSAnswer(int communicationSocket, struct addrinfo *freeAddress);

#endif // DNS_FUNCTIONS_H
