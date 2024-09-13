<?php

ini_set('display_error', 'stderr');

const SUCCESS = 0;       // spravně
//Errors
const PARAMS_ERROR = 10; // chybějící parametr skriptu nebo zakázaná kombinace parametrů
const FILEIN_ERROR = 11; // chyba při otevírání vstupních souborů
const HEADER_ERROR = 21; // chybná nebo chybějící hlavička
const LEXSYN_ERROR = 23; // lexikální nebo syntaktická chyba zdrojového kódu

// creating xml document headers
function start($xmlfile){
    xmlwriter_set_indent($xmlfile, 1);
    xmlwriter_set_indent_string($xmlfile, '  ');
    xmlwriter_start_document($xmlfile, '1.0', 'UTF-8');
    xmlwriter_start_element($xmlfile, "program");
    xmlwriter_start_attribute($xmlfile, "language");
    xmlwriter_text($xmlfile, "IPPcode22");
    xmlwriter_end_attribute($xmlfile);
}

function line($line,$pattern){
    $line = trim($line);
    return preg_split($pattern, $line);
}

function xml_start($xmlfile,$order,$instruction){
    //Element instruction
    xmlwriter_start_element($xmlfile, "instruction");
    //Attribute order
    xmlwriter_start_attribute($xmlfile, "order");
    xmlwriter_text($xmlfile, $order);
    xmlwriter_end_attribute($xmlfile);
    //Attribute opcode
    xmlwriter_start_attribute($xmlfile, "opcode");
    xmlwriter_text($xmlfile, $instruction);
    xmlwriter_end_attribute($xmlfile);
}

//control and processing of VAR
function xml_var($xmlfile, $arg){
    xmlwriter_start_element($xmlfile, "arg1");
    xmlwriter_start_attribute($xmlfile, "type");
    xmlwriter_text($xmlfile, "var");
    xmlwriter_end_attribute($xmlfile);

    if (preg_match("/^(GF|LF|TF)@/", $arg))
    {
        xmlwriter_text($xmlfile, $arg);
        xmlwriter_end_element($xmlfile);
    } else {
        fwrite(STDERR, "Wrong variable\n");
        exit(LEXSYN_ERROR);
    }
}

//control and processing of LABEL
function xml_label($xmlfile, $arg){
    xmlwriter_start_element($xmlfile, "arg1");
    xmlwriter_start_attribute($xmlfile, "type");
    xmlwriter_text($xmlfile, "label");
    xmlwriter_end_attribute($xmlfile);
    xmlwriter_text($xmlfile, $arg);
    xmlwriter_end_element($xmlfile);
}

//control and processing of TYPE
function xml_type($xmlfile,$arg){
    xmlwriter_start_element($xmlfile, "arg2");
    xmlwriter_start_attribute($xmlfile, "type");
    if (preg_match("/^(string|bool|int|nil)$/", $arg))
    {
        xmlwriter_text($xmlfile, "type");
        xmlwriter_end_attribute($xmlfile);
    } else {
        fwrite(STDERR, "Wrong type\n");
        exit(LEXSYN_ERROR);
    }
    xmlwriter_text($xmlfile, $arg);
    xmlwriter_end_element($xmlfile);
}

//control and processing of SYMB
function xml_symb($xmlfile,$arg){
    if (preg_match('/^(GF|LF|TF)@[_\-$%*?!&a-zA-Z0-9]+$/', $arg))
    {
        xmlwriter_text($xmlfile, "var");
    } else if (preg_match('/^string@(?:[^\s#]|(\\[0-9]{3}))*$|^int@[+-]?[0-9]+$|^bool@(true|false)$|^nil@nil$/', $arg))
    {
        $arg_type = preg_split ('/@+/',$arg);
        $pattern = "/$arg_type[0]@/";
        $arg = preg_replace($pattern, "", $arg);
        xmlwriter_text($xmlfile, $arg_type[0]);
    } else {
        fwrite(STDERR, "Wrong < symb >\n");
        exit(LEXSYN_ERROR);
    }
    xmlwriter_end_attribute($xmlfile);
    xmlwriter_text($xmlfile, $arg);
    xmlwriter_end_element($xmlfile);
}

//--help
if($argc > 1)
{
    if ($argv[1] == "--help") {
        echo("IPP project 2021/2022\n");
        echo("Autor: Taipova Evgeniya xtaipo00\n");
        echo("parseкк.php čte ze standardního vstupu zdrojový kód v IPPcode22,\n");
        echo("kontroluje lexikální a syntaktickou správnost kódu\n");
        echo("a vypisuje na standardní výstup XML  reprezentaci programu\n");
        echo("Doporučuje se použít verzi PHP 8.1\n");
        echo("Spuštění: $ php parse.php < FILE > output.out\n");
        exit(SUCCESS);
    } else {
        fwrite(STDERR, "Wrong number of parameters\n");
        exit(PARAMS_ERROR);
    }
}

//header check
$line = fgets(STDIN);
$line = preg_replace("/#.*$/", "", $line);
$line = trim($line);
if($line != ".IPPcode22"){
    fwrite(STDERR, "Wrong header\n");
    exit(HEADER_ERROR);
}

$xmlfile= xmlwriter_open_uri("php://stdout");
start($xmlfile);


$order= 0;

while (($line= fgets(STDIN)))
{
    //delete comment
    $pattern = '/#/';
    $word = line($line,$pattern);
    if ($word[0]!="")
    {
        $line=$word[0];
    }
    $pattern = '/\s+/';
    $word = line($line,$pattern);

    //control and processing of instruction element
    $word[0] = strtoupper($word[0]);
    switch($word[0])
    {
        case 'CREATEFRAME':
        case 'PUSHFRAME':
        case 'POPFRAME ':
        case 'RETURN':
        case 'BREAK':
            if (sizeof($word) == 1)
            {
                $order++;
                xml_start($xmlfile,$order,$word[0]);
                xmlwriter_end_element($xmlfile);
            }
            else {
                fwrite(STDERR, "Syntax error\n");
                exit(LEXSYN_ERROR);
            }
            break;

            //⟨label⟩
        case 'CALL':
        case 'LABEL':
        case 'JUMP':
            if (sizeof($word) == 2){
                $order++;
                xml_start($xmlfile,$order,$word[0]);
                xml_label($xmlfile, $word[1]);
                xmlwriter_end_element($xmlfile);
            }
            else {
                fwrite(STDERR, "Syntax error in ⟨label⟩ instruction\n");
                exit(LEXSYN_ERROR);
            }
            break;

            //⟨var⟩
        case 'POPS':
        case 'DEFVAR':
            if (sizeof($word) == 2)
            {
                $order++;
                xml_start($xmlfile,$order,$word[0]);
                xml_var($xmlfile,$word[1]);
                xmlwriter_end_element($xmlfile);
            }
            else {
                fwrite(STDERR, "Syntax error in ⟨var⟩ instruction\n");
                exit(LEXSYN_ERROR);
            }
            break;

            //⟨symb⟩
        case 'DPRINT':
        case 'PUSHS':
        case 'EXIT':
        case 'WRITE':
            if (sizeof($word) == 2)
            {
                $order++;
                xml_start($xmlfile,$order,$word[0]);
                xmlwriter_start_element($xmlfile, "arg1");
                xmlwriter_start_attribute($xmlfile, "type");
                xml_symb($xmlfile,$word[1]);
                xmlwriter_end_element($xmlfile);
            }
            else {
                fwrite(STDERR, "Syntax error in ⟨symb⟩ instruction\n");
                exit(LEXSYN_ERROR);
            }
            break;

            //⟨var⟩ ⟨type⟩
        case 'READ':
            if (sizeof($word) == 3)
            {
                $order++;
                xml_start($xmlfile,$order,$word[0]);
                xml_var($xmlfile, $word[1]);
                xml_type($xmlfile,$word[2]);
                xmlwriter_end_element($xmlfile);
            }
            else {
                fwrite(STDERR, "Syntax error in READ\n");
                exit(LEXSYN_ERROR);
            }
            break;

            //⟨var⟩ ⟨symb⟩
        case 'INT2CHAR':
        case 'STRLEN':
        case 'TYPE':
        case 'MOVE':
        case 'NOT':
            if (sizeof($word) == 3)
            {
                $order++;
                xml_start($xmlfile,$order,$word[0]);
                xml_var($xmlfile,$word[1]);
                xmlwriter_start_element($xmlfile, "arg2");
                xmlwriter_start_attribute($xmlfile, "type");
                xml_symb($xmlfile,$word[2]);
                xmlwriter_end_element($xmlfile);
            }
            else {
                fwrite(STDERR, "Syntax error in ⟨var⟩ ⟨symb⟩ instruction\n");
                exit(LEXSYN_ERROR);
            }
            break;

            //⟨label⟩ ⟨symb1⟩ ⟨symb2⟩
        case 'JUMPIFEQ':
        case 'JUMPIFNEQ':
            if (sizeof($word) == 4){
                $order++;
                xml_start($xmlfile,$order,$word[0]);
                xml_label($xmlfile, $word[2]);
                xmlwriter_start_element($xmlfile, "arg2");
                xmlwriter_start_attribute($xmlfile, "type");
                xml_symb($xmlfile,$word[2]);
                xmlwriter_start_element($xmlfile, "arg3");
                xmlwriter_start_attribute($xmlfile, "type");
                xml_symb($xmlfile,$word[3]);
                xmlwriter_end_element($xmlfile);
            } else {
                fwrite(STDERR, "Syntax error in ⟨label⟩⟨symb1⟩⟨symb2⟩ instruction\n");
                exit(LEXSYN_ERROR);
            }
            break;

            //⟨var⟩ ⟨symb1⟩ ⟨symb2⟩
        case 'ADD':
        case 'SUB':
        case 'MUL':
        case 'IDIV':
        case 'LT':
        case 'GT':
        case 'EQ':
        case 'AND':
        case 'OR':
        case 'STRI2INT':
        case 'CONCAT':
        case 'GETCHAR':
        case 'SETCHAR':
        if (sizeof($word) == 4){
            $order++;
            xml_start($xmlfile,$order,$word[0]);
            xml_var($xmlfile, $word[2]);
            xmlwriter_start_element($xmlfile, "arg2");
            xmlwriter_start_attribute($xmlfile, "type");
            xml_symb($xmlfile,$word[2]);
            xmlwriter_start_element($xmlfile, "arg3");
            xmlwriter_start_attribute($xmlfile, "type");
            xml_symb($xmlfile,$word[3]);
            xmlwriter_end_element($xmlfile);
        } else {
            fwrite(STDERR, "Syntax error in ⟨var⟩⟨symb1⟩⟨symb2⟩ instruction\n");
            exit(LEXSYN_ERROR);
        }
        break;
    }
}

//end of xml document
xmlwriter_end_element($xmlfile);
xmlwriter_end_document($xmlfile);
xmlwriter_output_memory($xmlfile);
?>