#  Projekt: DNS Resolver
#  Autor: Taipova Evgeniya
#  Login: xtaipo00
#  Předmět: Síťové aplikace a správa sítí (ISA)
#  Datum: 20.11.2023

import subprocess

SERVER = "kazi.fit.vutbr.cz"
print("")
print(f"TESTS IPV4")
print("")
def test_ipv4(name, server):
    # Capture output of dig +short
    expected_output = subprocess.getoutput(f'dig +short {name} @{server} 2>/dev/null')

    # Run dns with appropriate options and capture output
    actual_output = subprocess.getoutput(f'./dns -r -s {server} {name} | grep "IN," | cut -d "," -f 5 | grep "[[:space:]]" | sed -e \'s/^ *//g\' | grep -v "adresa"')
    print(f"------------------------------------------")
    # Compare dig and dns outputs
    if expected_output == actual_output:
        print(f"test_ipv4 {name} SUCCESS")
    else:
        print(f"test_ipv4 {name} ERROR")
        print(f"Expected output: {expected_output}")
        print(f"Actual output: {actual_output}")
        
test_ipv4("example.com", SERVER)
test_ipv4("www.example.com", SERVER)
test_ipv4("www.fit.vut.cz", SERVER)
test_ipv4("merlin.fit.vutbr.cz", SERVER)

print("")
print(f"TESTS IPV4 REVERSE")
print("")
def test_reverse_ipv4(name, server):
    # Capture output of dig +short -x
    expected_output = subprocess.getoutput(f'dig +short -x {name} @{server} 2>/dev/null')

    # Run dns with appropriate options and capture output
    actual_output = subprocess.getoutput(
        f'./dns -r -x -s {server} {name} | grep "IN," | cut -d "," -f 5 | grep "[[:space:]]" | sed -e \'s/^ *//g\' | grep -v "adresa"')
    print(f"------------------------------------------")
    # Compare dig and dns outputs
    if expected_output == actual_output:
        print(f"test_reverse_ipv4: {name} PTR SUCCESS")
    else:
        print(f"test_reverse_ipv4: {name} PTR ERROR")
        print(f"Expected output: {expected_output}")
        print(f"Actual output: {actual_output}")

test_reverse_ipv4("8.8.8.8", SERVER)
test_reverse_ipv4("127.0.0.1", SERVER)
test_reverse_ipv4("192.168.1.1", SERVER)
test_reverse_ipv4("203.0.113.254", SERVER)

print("")
print(f"TESTS IPV6")
print("")
def test_ipv6(name, server):
    # Capture output of dig +short AAAA
    expected_output = subprocess.getoutput(f'dig +short AAAA {name} @{server} 2>/dev/null')

    # Run dns with appropriate options and capture output
    actual_output = subprocess.getoutput(f'./dns -r -6 -s {server} {name} | grep "IN," | cut -d "," -f 5 | grep "[[:space:]]" | sed -e \'s/^ *//g\' | grep -v "adresa"')
    
    print(f"------------------------------------------")
    # Compare dig and dns outputs
    if expected_output == actual_output:
        print(f"test_ipv6 {name} AAAA SUCCESS")
    else:
        print(f"test_ipv6 {name} AAAA ERROR")
        print(f"Expected output: {expected_output}")
        print(f"Actual output: {actual_output}")

# IPv6 tests
test_ipv6("fit.vut.cz", SERVER)
test_ipv6("www.fit.vut.cz", SERVER)
test_ipv6("merlin.fit.vutbr.cz", SERVER)
test_ipv6("google.com", SERVER)

print("")
print(f"TESTS IPV6 REVERSE")
print("")
def test_reverse_ipv6(name, server):
    # Capture output of dig +short -x
    expected_output = subprocess.getoutput(f'dig +short -x {name} @{server} 2>/dev/null')

    # Run dns with appropriate options and capture output
    actual_output = subprocess.getoutput(
        f'./dns -r -x -s {server} {name} | grep "IN," | cut -d "," -f 5 | grep "[[:space:]]" | sed -e \'s/^ *//g\' | grep -v "adresa"')

    print(f"------------------------------------------")
    # Compare dig and dns outputs
    if expected_output == actual_output:
        print(f"test_reverse_ipv6: {name} PTR SUCCESS")
    else:
        print(f"test_reverse_ipv6: {name} PTR ERROR")
        print(f"Expected output: {expected_output}")
        print(f"Actual output: {actual_output}")

test_reverse_ipv6("2a00:1450:4014:80d::200e", SERVER)
test_reverse_ipv6("2001:4860:4860::8888", SERVER)
test_reverse_ipv6("www.fit.vut.cz", SERVER)
test_reverse_ipv6("::1", SERVER)
