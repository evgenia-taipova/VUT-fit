# IPP project 2021/2022
# Taipova Evgeniya xtaipo00
# interpret.py

import re
import sys
import argparse
import xml.etree.ElementTree

SUCCESS = 0
# ERRORS
PARAMS_ERROR = 10          # missing script parameter or use of forbidden parameter combination
XML_FORMAT_ERROR = 31      # wrong XML format in input file
XML_STRUCTURE_ERROR = 32   # unexpected XML structure
SEMANTIC_ERROR = 52        # error during semantic checks of access code in IPPcode22
WRONG_TYPE_ERROR = 53      # wrong types of operands
NO_FRAME_ERROR = 55        # frame does not exist
MISSING_VALUE_ERROR = 56   # missing value
WRONG_VALUE_ERROR = 57     # wrong operand value
WRONG_STRING_ERROR = 58    # incorrect string operation

xml_file = None
input_file = None

# Add arguments
arg = argparse.ArgumentParser(add_help=False)
arg.add_argument('--help', action='store_true')
arg.add_argument('--source')
arg.add_argument('--input')
arguments = arg.parse_args()

# control arguments and display help if needed
def check_args():
    global xml_file, input_file
    if arguments.source:
        xml_file = open(arguments.source)
    elif arguments.input:
        input_file = open(arguments.input)
    elif not (arguments.source or arguments.input):
        sys.exit(PARAMS_ERROR)
    elif arguments.help:
        if len(sys.argv) != 2:
            sys.exit(PARAMS_ERROR)
        else:
            # --help
            print("IPP project 2021/2022")
            print("Author: Taipova Evgeniya xtaipo00")
            print("interpret.py reads the XML representation of the program and")
            print("this program interprets and generates the output ")
            print("using the input according to the command line parameters.")
            print("Recommend using Python version 3.8.")

            print("--source=file  Input file with XML representation of source code")
            print("--input=file   Input file for the interpretation of the specified source code")

            print("At least one of the parameters (--source or --input) must always be specified.")
            print("If one of them is missing, the missing data is read from standard input.")
            sys.exit(SUCCESS)

frames = dict(GF={})
stack_frame = []
stack_call = []
stack_data = []
labels = dict()


# print to standard error output
def print_stderr(str):
    print(str, file=sys.stderr)

# Functions for frame
# Split the variable into frame and name
# Frame
def name_1(arg):
    var = arg['value'][0:2]
    return var

# Name
def name_2(arg):
    var = arg['value'][3:]
    return var

# Set variable name, value and type
def set_var(arg, value_type, str):
    frames[name_1(arg)][name_2(arg)][str] = value_type

# Return variable name, value and type
def get_var(arg,str):
    var = frames[name_1(arg)][name_2(arg)][str]
    return var

# Get type or value of variable
# :str: can be 'type' or 'value'
def get_type_value(arg, str):
    if not 'var' == arg['type']:
        return arg[str]
    else:
        return get_var(arg,str)


def get_label(arg):
    if arg['value'] in labels:
        return labels[arg['value']]
    else:
        print_stderr('Label is missing')
        sys.exit(SEMANTIC_ERROR)

# Instruction process
# Working with frames, function calls (MOVE, CREATEFRAME, PUSHFRAME, POPFRAME, DEFVAR, CALL, RETURN)

# Copies the value of arguments[1] to arguments[0].
def move(arguments):
    var_val = get_type_value(arguments[1], 'value')
    var_type = get_type_value(arguments[1], 'type')
    set_var(arguments[0], var_val, 'value')
    set_var(arguments[0], var_type, 'type')

# Create a new temporary framework
def createframe(arguments):
    frames['TF'] = {}

# Move a temporary frame to the frame stack
def pushframe(arguments):
    if 'TF' in frames:
        frames['LF'] = frames['TF']
    else:
        print_stderr("Frame is empty")
        sys.exit(NO_FRAME_ERROR)

# Move the local frame to a temporary frame
def popframe(arguments):
    if not 'LF' in frames:
        print_stderr('Frame is empty')
        sys.exit(NO_FRAME_ERROR)
    frames['TF'] = frames['LF']

# Definition of a variable in a given framework
def defvar(arguments):
    var1 = name_1(arguments[0])
    var2 = name_2(arguments[0])
    if not var1 in frames:
        print_stderr("Frame is empty")
        sys.exit(NO_FRAME_ERROR)
    elif var2 in frames[var1]:
        print_stderr('DEFVAR error')
        sys.exit(SEMANTIC_ERROR)
    frames[var1][var2] = dict(value=None, type=None)


instruction_index = 0
instruction_count = 0

# Jump to the specified position with saved return
def call(arguments):
    global instruction_index, stack_call
    stack_call.append(instruction_index)

# Return to the position stored by the CALL instruction
def return_instruction(arguments):
    global instruction_index, stack_call
    instruction_index = stack_call.pop()

# Arithmetic, relational, Boolean and conversion instructions (ADD, SUB, MUL, IDIV, LT, GT, EQ, AND, OR, NOT, INT2CHAR, STRI2INT)

# The sum of two numerical values
def add(arguments):
    arg1_type = get_type_value(arguments[1], 'type')
    arg2_type = get_type_value(arguments[2], 'type')
    arg1_value = get_type_value(arguments[1], 'value')
    arg2_value = get_type_value(arguments[2], 'value')
    if arg1_type == 'int' and arg2_type == 'int':
        value = arg1_value + arg2_value
        set_var(arguments[0], arg1_type, 'type')
        set_var(arguments[0], value, 'value')
    else:
        print_stderr('ADD error')
        sys.exit(WRONG_TYPE_ERROR)

# Subtraction of two numerical values
def sub(arguments):
    arg1_type = get_type_value(arguments[1], 'type')
    arg2_type = get_type_value(arguments[2], 'type')
    arg1_value = get_type_value(arguments[1], 'value')
    arg2_value = get_type_value(arguments[2], 'value')
    if arg1_type == 'int' and arg2_type == 'int':
        value = arg1_value - arg2_value
        set_var(arguments[0], arg1_type, 'type')
        set_var(arguments[0], value, 'value')
    else:
        print_stderr('SUB error')
        sys.exit(WRONG_TYPE_ERROR)


# Multiplication of two numeric values
def mul(arguments):
    arg1_type = get_type_value(arguments[1], 'type')
    arg2_type = get_type_value(arguments[2], 'type')
    arg1_value = get_type_value(arguments[1], 'value')
    arg2_value = get_type_value(arguments[2], 'value')
    if arg1_type == 'int' and arg2_type == 'int':
        value = arg1_value * arg2_value
        set_var(arguments[0], arg1_type, 'type')
        set_var(arguments[0], value, 'value')
    else:
        print_stderr('MUL error')
        sys.exit(WRONG_TYPE_ERROR)

# Dividing two integer values
def idiv(arguments):
    arg1_type = get_type_value(arguments[1], 'type')
    arg2_type = get_type_value(arguments[2], 'type')
    arg1_value = get_type_value(arguments[1], 'value')
    arg2_value = get_type_value(arguments[2], 'value')
    if arg2_value == 0:
        print_stderr('Division by zero')
        sys.exit(WRONG_VALUE_ERROR)

    if arg1_type == 'int' and arg2_type == 'int':
        value = arg1_value // arg2_value
        set_var(arguments[0], arg1_type , 'type')
        set_var(arguments[0], value, 'value')
    else:
        print_stderr('IDIV error')
        sys.exit(WRONG_TYPE_ERROR)

# Relational operator less (<)
def lt(arguments):
    arg1_type = get_type_value(arguments[1], 'type')
    arg2_type = get_type_value(arguments[2], 'type')
    if arg1_type != 'nil':
        if arg1_type == arg2_type:
            set_var(arguments[0], 'bool', 'type')
            arg1_value = get_type_value(arguments[1], 'value')
            arg2_value = get_type_value(arguments[2], 'value')
            if arg1_value < arg2_value:
                set_var(arguments[0], True, 'value')
            else:
                set_var(arguments[0], False, 'value')
        else:
            print_stderr('LT error')
            sys.exit(WRONG_TYPE_ERROR)
    else:
        print_stderr('LT error')
        sys.exit(WRONG_TYPE_ERROR)

#Relational operator greater (>)
def gt(arguments):
    arg1_type = get_type_value(arguments[1], 'type')
    arg2_type = get_type_value(arguments[2], 'type')
    if arg1_type != 'nil':
        if arg1_type == arg2_type:
            set_var(arguments[0], 'bool', 'type')
            arg1_value = get_type_value(arguments[1], 'value')
            arg2_value = get_type_value(arguments[2], 'value')
            if arg1_value > arg2_value:
                set_var(arguments[0], True, 'value')
            else:
                set_var(arguments[0], False, 'value')
        else:
            print_stderr('GT error')
            sys.exit(WRONG_TYPE_ERROR)
    else:
        print_stderr('GT error')
        sys.exit(WRONG_TYPE_ERROR)

# Relational operator equals (=)
def eq(arguments):
    arg1_type = get_type_value(arguments[1], 'type')
    arg2_type = get_type_value(arguments[2], 'type')
    if arg1_type == arg2_type:
        set_var(arguments[0], 'bool', 'type')
        arg1_value = get_type_value(arguments[1], 'value')
        arg2_value = get_type_value(arguments[2], 'value')
        if arg1_value == arg2_value:
            set_var(arguments[0], True, 'value')
        else:
            set_var(arguments[0], False, 'value')
    else:
        print_stderr('EQ error')
        sys.exit(WRONG_TYPE_ERROR)

# Basic Boolean operators
# AND
def and_instruction(arguments):
    arg1_type = get_type_value(arguments[1], 'type')
    arg2_type = get_type_value(arguments[2], 'type')
    if arg1_type == 'bool' and arg2_type == 'bool':
        set_var(arguments[0], 'bool', 'type')
        value_and = get_type_value(arguments[1], 'value') and get_type_value(arguments[2], 'value')
        set_var(arguments[0], value_and, 'value')
    else:
        print_stderr('AND error')
        sys.exit(WRONG_TYPE_ERROR)

# OR
def or_instruction(arguments):
    arg1_type = get_type_value(arguments[1], 'type')
    arg2_type = get_type_value(arguments[2], 'type')
    if arg1_type == 'bool' and arg2_type == 'bool':
        set_var(arguments[0], 'bool', 'type')
        value_or = get_type_value(arguments[1], 'value') or get_type_value(arguments[2], 'value')
        set_var(arguments[0], value_or, 'value')
    else:
        print_stderr('OR error')
        sys.exit(WRONG_TYPE_ERROR)

# NOT
def not_instruction(arguments):
    arg1_type = get_type_value(arguments[1], 'type')
    if arg1_type == 'bool':
        set_var(arguments[0], 'bool', 'type')
        value_not =  not get_type_value(arguments[1], 'value')
        set_var(arguments[0], value_not, 'value')
    else:
        print_stderr('NOT error')
        sys.exit(WRONG_TYPE_ERROR)

# Convert an integer to a character
def int2char(arguments):
    arg1_type = get_type_value(arguments[1], 'type')
    if arg1_type == 'int':
        value = get_type_value(arguments[1], 'value')
    else:
        print_stderr('INT2CHAR error')
        sys.exit(WRONG_TYPE_ERROR)
    try:
        value = chr(value)
    except:
        print_stderr('INT2CHAR error')
        sys.exit(WRONG_STRING_ERROR)
    set_var(arguments[0], value, 'value')
    set_var(arguments[0], 'string', 'type')

# Ordinal value of the character
def stri2int(arguments):
    arg1_type = get_type_value(arguments[1], 'type')
    arg2_type = get_type_value(arguments[2], 'type')

    if arg1_type == 'string' and arg2_type == 'int':
        arg1_value = get_type_value(arguments[1], 'value')
        arg2_value = get_type_value(arguments[2], 'value')
    else:
        print_stderr('STRI2INT error')
        sys.exit(WRONG_TYPE_ERROR)
    if arg2_value < 0 or arg2_value > len(arg1_value)-1:
        print_stderr('STRI2INT index out of range')
        sys.exit(WRONG_STRING_ERROR)
    value = ord(arg1_value[arg2_value])
    set_var(arguments[0], value, 'value')
    set_var(arguments[0], 'int', 'type')

# I / O instructions (READ, WRITE)
# Read value from standard input
def read(arguments):
   pass

# Print the value to standard output
def write(arguments):
    type = get_type_value(arguments[0], 'type')
    value = get_type_value(arguments[0], 'value')
    if type == 'bool':
        print(str(value), end='')
    elif type == 'int' or type == 'string':
        print(value, end='')
    else:
        print('', end='')

# Working with strings (CONCAT, STRLEN, GETCHAR, SETCHAR)
# Concatenation of two strings
def concat(arguments):
    argument_type_1 = get_type_value(arguments[1], 'type')
    argument_type_2 = get_type_value(arguments[2], 'type')
    argument_value_1 = get_type_value(arguments[1], 'value')
    argument_value_2 = get_type_value(arguments[2], 'value')

    if argument_type_1 == 'string' and argument_type_2 == 'string':
        value_concat = argument_value_1 + argument_value_2
        set_var(arguments[0], 'string', 'type')
        set_var(arguments[0], value_concat, 'value')
    else:
        print_stderr('CONCAT error')
        sys.exit(WRONG_TYPE_ERROR)

# Find the length of the string
def strlen(arguments):
    type = get_type_value(arguments[1], 'type')
    value = get_type_value(arguments[1], 'value')
    if type == 'string':
        set_var(arguments[0], 'int', 'type')
        set_var(arguments[0], len(value), 'value')
    else:
        print_stderr('STRLEN error')
        sys.exit(WRONG_TYPE_ERROR)

# Return a string character
def getchar(arguments):
    arg1_type = get_type_value(arguments[1], 'type')
    arg2_type = get_type_value(arguments[2], 'type')
    if arg1_type == 'string' and arg2_type== 'int':
        arg1_value = get_type_value(arguments[1], 'value')
        arg2_value = get_type_value(arguments[2], 'value')
    else:
        print_stderr('GETCHAR error')
        sys.exit(WRONG_TYPE_ERROR)
    if arg2_value < 0:
        print_stderr('GETCHAR arg2_value is < 0')
        sys.exit(WRONG_STRING_ERROR)
    try:
        value = arg1_value[arg2_value]
    except:
        print_stderr('GETCHAR arg2_value is out of boundaries')
        sys.exit(WRONG_STRING_ERROR)
    set_var(arguments[0], 'string', 'type')
    set_var(arguments[0], value, 'value')

# Change the string character
def setchar(arguments):
    arg0_type = get_type_value(arguments[0], 'type')
    arg1_type = get_type_value(arguments[1], 'type')
    arg2_type = get_type_value(arguments[2], 'type')
    if arg0_type != 'string' or arg1_type != 'int' or arg2_type != 'string':
        print_stderr('SETCHAR error')
        sys.exit(WRONG_TYPE_ERROR)
    arg1_value = get_type_value(arguments[1], 'value')
    if arg1_value < 0:
        print_stderr('SETCHAR arg1_value is < 0')
        sys.exit(WRONG_STRING_ERROR)
    try:
        arg0_value = get_type_value(arguments[0], 'value')
        arg2_value = get_type_value(arguments[2], 'value')
        arg0_value = list(arg0_value)
        arg0_value[index] = arg2_value[0]
        arg0_value = ''.join(arg0_value)
        set_var(arguments[0], arg0_value, 'value')
    except:
        print_stderr('SETCHAR error')
        sys.exit(WRONG_STRING_ERROR)

# Working with types (TYPE)
# Find the type of the symbol
def type(arguments):
    if not arguments[1]['type'] == 'var':
        type = arguments[1]['type']
    else:
        type = get_var(arguments[1], 'type')
        if type is None:
            type = ''
    set_var(arguments[0], 'string', 'type')
    set_var(arguments[0], type, 'value')

# Unconditional jump on the label
def jump(arguments):
        global instruction_index
        instruction_index = get_label(arguments[0])

# Conditional jump on the label at equality
def jumpifeq(arguments):
    global instruction_index
    arg1_type = get_type_value(arguments[1], 'type')
    arg2_type = get_type_value(arguments[2], 'type')
    arg1_value = get_type_value(arguments[1], 'value')
    arg2_value = get_type_value(arguments[2], 'value')
    if arg1_type == 'nil' or arg2_type == 'nil':
        return
    if arg1_type == arg2_type:
        label = get_label(arguments[0])
    else:
        print_stderr('JUMPIFEQ error')
        sys.exit(WRONG_TYPE_ERROR)
    if arg1_value == arg2_value:
        instruction_index = label

# Conditional jump on label when uneven
def jumpifneq(arguments):
    global instruction_index
    arg1_type = get_type_value(arguments[1], 'type')
    arg2_type = get_type_value(arguments[2], 'type')
    arg1_value = get_type_value(arguments[1], 'value')
    arg2_value = get_type_value(arguments[2], 'value')
    if arg1_type == 'nil' or arg2_type == 'nil':
        instruction_index = get_label(arguments[0])
        return
    if arg1_type != arg2_type:
        print_stderr('JUMPIFNEQ error')
        sys.exit(WRONG_TYPE_ERROR)

    label = get_label(arguments[0])
    if arg2_value != arg1_value:
        instruction_index = label

# End of interpretation with return code
def exit(arguments):
    global control_exit
    type = get_type_value(arguments[0], 'type')
    if type == 'int':
        value = get_type_value(arguments[0], 'value')
    else:
        print_stderr('EXIT error')
        sys.exit(WRONG_TYPE_ERROR)
    if not (value < 0 or val > 49):
        sys.exit(value)
    else:
        print_stderr('EXIT error')
        sys.exit(WRONG_VALUE_ERROR)

# Working with the data stack
# Insert a value at the top of the data stack
def pushs(arguments):
    global stack_data
    arg_value = get_type_value(arguments[0], 'value')
    arg_type = get_type_value(arguments[0], 'type')
    stack_data.append(dict(value=arg_value, type=arg_type))

# Remove the value from the top of the data stack
def pops(arguments):
    global stack_data
    if stack_data:
        var = stack_data.pop()
        set_var(arguments[0], var['value'], 'value')
        set_var(arguments[0], var['type'], 'type')
    else:
        print_stderr('POP: Data stack is empty')
        sys.exit(MISSING_VALUE_ERROR)

# Delete values of the data stack
def clears(arguments):
    global stack_data
    stack_data = []

# Select two values from the data stack, sum them and save the result at the top of the data stack
def adds(arguments):
    arg2 = stack_data.pop()
    arg1 = stack_data.pop()
    arg1_type = get_type_value(arg1, 'type')
    arg2_type = get_type_value(arg2, 'type')
    if arg1_type == 'int' and arg2_type == 'int':
        arg1_value = get_type_value(arg1, 'value')
        arg2_value = get_type_value(arg2, 'value')
        arg_value = arg1_value + arg2_value
        stack_data.append(dict(value= arg_value , type='int'))
    else:
        print_stderr('ADDS error')
        sys.exit(WRONG_TYPE_ERROR)

# Select two values from the data stack, subtract the second from the first and save the result at the top of the stack
def subs(arguments):
    arg2 = stack_data.pop()
    arg1 = stack_data.pop()
    arg1_type = get_type_value(arg1, 'type')
    arg2_type = get_type_value(arg2, 'type')
    if arg1_type == 'int' and arg2_type == 'int':
        arg1_value = get_type_value(arg1, 'value')
        arg2_value = get_type_value(arg2, 'value')
        arg_value = arg1_value - arg2_value
        stack_data.append(dict(value=arg_value, type='int'))
    else:
        print_stderr('SUBS error')
        sys.exit(WRONG_TYPE_ERROR)

# Select two values from the data stack, multiple them and save the result at the top of the data stack
def muls(arguments):
    arg2 = stack_data.pop()
    arg1 = stack_data.pop()
    arg1_type = get_type_value(arg1, 'type')
    arg2_type = get_type_value(arg2, 'type')
    if arg1_type == 'int' and arg2_type == 'int':
        arg1_value = get_type_value(arg1, 'value')
        arg2_value = get_type_value(arg2, 'value')
        arg_value = arg1_value * arg2_value
        stack_data.append(dict(value=arg_value, type='int'))
    else:
        print_stderr('MULS error')
        sys.exit(WRONG_TYPE_ERROR)

# Selects two values from the data stack, the first number is divisible by the second and save the result at the top of the data stack
def idivs(arguments):
    arg2 = stack_data.pop()
    arg1 = stack_data.pop()
    arg1_type = get_type_value(arg1, 'type')
    arg2_type = get_type_value(arg2, 'type')
    arg1_value = get_type_value(arg1, 'value')
    arg2_value = get_type_value(arg2, 'value')
    if arg2_value == 0:
        print_stderr('IDIVS error')
        sys.exit(WRONG_VALUE_ERROR)
    if arg1_type == 'int' and arg2_type == 'int':
        arg_value = arg1_value // arg2_value
        stack_data.append(dict(value=arg_value, type='int'))
    else:
        print_stderr('IDIVS error')
        sys.exit(WRONG_TYPE_ERROR)

# Select two values from the data stack and apply a logical conjunction to them
def ands(arguments):
    arg2 = stack_data.pop()
    arg1 = stack_data.pop()
    arg1_type = get_type_value(arg1, 'type')
    arg2_type = get_type_value(arg2, 'type')
    arg1_value = get_type_value(arg1, 'value')
    arg2_value = get_type_value(arg2, 'value')
    if arg1_type == 'bool' and arg2_type == 'bool':
        arg_value = arg1_value and arg2_value
        stack_data.append(dict(value=arg_value, type='bool'))
    else:
        print_stderr('ANDS error')
        sys.exit(WRONG_TYPE_ERROR)

# Select two values from the data stack and apply logical disjunction to them
def ors(arguments):
    arg2 = stack_data.pop()
    arg1 = stack_data.pop()
    arg1_type = get_type_value(arg1, 'type')
    arg2_type = get_type_value(arg2, 'type')
    arg1_value = get_type_value(arg1, 'value')
    arg2_value = get_type_value(arg2, 'value')
    if arg1_type == 'bool' and arg2_value == 'bool':
        arg_value = arg1_value or arg2_value
        stack_data.append(dict(value=arg_value, type='bool'))
    else:
        print_stderr('ORS error')
        sys.exit(WRONG_TYPE_ERROR)

# Select a value from the data stack, negate it and save to the data stack again
def nots(arguments):
    arg1 = stack_data.pop()
    arg1_type = get_type_value(arg1, 'type')
    if get_type_value(arg1, 'type') == 'bool':
        arg_value = not get_type_value(arg1, 'value')
        stack_data.append(dict(value= arg_value, type='bool'))
    else:
        print_stderr('NOTS error')
        sys.exit(WRONG_TYPE_ERROR)

# The instruction set of IPPcode22 with arguments
instruction_set = dict(
    CREATEFRAME=dict(arguments=[]), PUSHFRAME=dict(arguments=[]), POPFRAME=dict(arguments=[]),RETURN=dict(arguments=[]),
    CALL=dict(arguments=['label']), LABEL=dict(arguments=['label']),JUMP=dict(arguments=['label']),
    DEFVAR=dict(arguments=['var']), POPS=dict(arguments=['var']),
    PUSHS=dict(arguments=['symb']), EXIT=dict(arguments=['symb']), WRITE=dict(arguments=['symb']),
    READ=dict(arguments=['var', 'type']),
    INT2CHAR=dict(arguments=['var', 'symb']),STRLEN=dict(arguments=['var', 'symb']), TYPE=dict(arguments=['var', 'symb']),
    NOT=dict(arguments=['var', 'symb']), MOVE=dict(arguments=['var', 'symb']),
    JUMPIFEQ=dict(arguments=['label', 'symb', 'symb']),JUMPIFNEQ=dict(arguments=['label', 'symb', 'symb']),
    ADD=dict(arguments=['var', 'symb', 'symb']),SUB=dict(arguments=['var', 'symb', 'symb']),
    MUL=dict(arguments=['var', 'symb', 'symb']),IDIV=dict(arguments=['var', 'symb', 'symb']),
    LT=dict(arguments=['var', 'symb', 'symb']), GT=dict(arguments=['var', 'symb', 'symb']),
    EQ=dict(arguments=['var', 'symb', 'symb']), AND=dict(arguments=['var', 'symb', 'symb']),
    OR=dict(arguments=['var', 'symb', 'symb']), STRI2INT=dict(arguments=['var', 'symb', 'symb']),
    CONCAT=dict(arguments=['var', 'symb', 'symb']), GETCHAR=dict(arguments=['var', 'symb', 'symb']),
    SETCHAR=dict(arguments=['var', 'symb', 'symb']),
    DPRINT=dict(arguments=['symb']),
    BREAK=dict(arguments=[]),
    CLEARS=dict(arguments=[]), ADDS=dict(arguments=[]),
    SUBS=dict(arguments=[]), MULS=dict(arguments=[]), IDIVS=dict(arguments=[]),
    ANDS=dict(arguments=[]), ORS=dict(arguments=[]), NOTS=dict(arguments=[]))

# Replace numeric escape sequences with characters
def escape_sequence(symb_name):
    esc_seq_list = re.findall('(\\\\[0-9]{3})', str(symb_name))
    while (len(esc_seq_list) > 0):
        esc_seq = esc_seq_list[0]
        symb_name = symb_name.replace(esc_seq, chr(int(esc_seq.replace("\\", ""))))
        while (esc_seq in esc_seq_list):
            esc_seq_list.remove(esc_seq)
    return symb_name

# Modify the value of the variable depending on type
def modify_value(var_type, value):
    mod_value = value
    if var_type == 'bool':
        if value == 'true':
            mod_value = True
        else:
            mod_value = False
    elif var_type == 'int':
        mod_value = int(value)
    elif var_type == 'nil':
        mod_value = ''
    elif var_type == 'string':
        mod_value = escape_sequence(value)
    return mod_value

def main():
    global instruction_set
    global instruction_index, instruction_count
    check_args()
    order_list = []
    try:
        tree = xml.etree.ElementTree.parse(xml_file)
    except:
        sys.exit(XML_FORMAT_ERROR)
    root = tree.getroot()

    # Check the root of the tree and its attribute
    code = root.attrib['language'].lower()
    if not (root.tag == 'program' and 'language' in root.attrib and code == 'ippcode22'):
        sys.exit(XML_STRUCTURE_ERROR)

    # Check instructions and their attributes
    for instruction in root:

        if instruction.tag != 'instruction' or 'opcode' not in instruction.attrib:
            sys.exit(XML_STRUCTURE_ERROR)

        order = instruction.attrib['order']
        instruction_name = instruction.attrib['opcode'].upper()
        # Instruction numbers must not be repeated and must have a number greater than 0
        if order not in order_list and int(order) > 0:
            order_list.append(order)
        else:
            sys.exit(XML_STRUCTURE_ERROR)

        instruction[:] = sorted(instruction, key=lambda child: child.tag)
        arguments = []
        arg_pos = 1
        #Check if type of argument is correct
        for argument in instruction:
            argument.attrib['type'] = argument.attrib['type'].lower()
            control = 1
            if argument.attrib['type'] == 'int' and not re.match('^[+\-]?\d+$', argument.text):
                control = 0
            elif argument.attrib['type'] == 'var' and not re.match('^(GF|LF|TF)@[a-zA-Z_\-$&%*!?][\w\-$&%*!?]*$', argument.text):
                control = 0
            elif argument.attrib['type'] == 'label' and not re.match('^[a-zA-Z_\-$&%*!?][\w\-$&%*!?]*$', argument.text):
                control = 0
            elif argument.attrib['type'] == 'bool' and not argument.text in ['true', 'false']:
                control = 0
            elif argument.attrib['type'] == 'nil' and not argument.text in ['nil']:
                control = 0
            elif argument.attrib['type'] == 'type' and not argument.text in ['int', 'bool', 'string']:
                control = 0

            if not ('type' in argument.attrib) \
            or not control \
            or argument.tag != ('arg' + str(arg_pos)) :
                sys.exit(XML_STRUCTURE_ERROR)

            value = modify_value(argument.attrib['type'], argument.text)
            arguments.append(dict(type=argument.attrib['type'], value=value))
            arg_pos = arg_pos+1

        # Check if instruction name is correct and if arguments count equal instruction arguments count
        if not instruction_name in instruction_set:
            sys.exit(XML_STRUCTURE_ERROR)
        if not len(instruction_set[instruction_name]['arguments']) == len(arguments):
            sys.exit(XML_STRUCTURE_ERROR)


        # Instruction processing
        if instruction_name == 'MOVE':
            move(arguments)
        if instruction_name == 'CREATEFRAME':
            createframe(arguments)
        if instruction_name == 'PUSHFRAME':
            pushframe((arguments))
        if instruction_name == 'POPFRAME':
            popframe(arguments)
        if instruction_name == 'DEFVAR':
            defvar(arguments)
        if instruction_name == 'CALL':
            call(arguments)
        if instruction_name == 'RETURN':
            return_instruction(arguments)
        if instruction_name == 'PUSHS':
            pushs(arguments)
        if instruction_name == 'POPS':
            pops(arguments)
        if instruction_name == 'ADD':
            add(arguments)
        if instruction_name == 'SUB':
            sub(arguments)
        if instruction_name == 'MUL':
            mul(arguments)
        if instruction_name == 'IDIV':
            idiv(arguments)
        if instruction_name == 'LT':
            lt(arguments)
        if instruction_name == 'GT':
            gt(arguments)
        if instruction_name == 'EQ':
            eq(arguments)
        if instruction_name == 'AND':
            and_instruction(arguments)
        if instruction_name == 'OR':
            or_instruction(arguments)
        if instruction_name == 'NOT':
            not_instruction(arguments)
        if instruction_name == 'INT2CHAR':
            int2char(arguments)
        if instruction_name == 'STRI2INT':
            stri2int(arguments)
        if instruction_name == 'READ':
            read(arguments)
        if instruction_name == 'WRITE':
            write(arguments)
        if instruction_name == 'TYPE':
            type(arguments)
        if instruction_name == 'LABEL':
            pass
        if instruction_name == 'JUMP':
            jump(arguments)
        if instruction_name == 'JUMPIFEQ':
            jumpifeq(arguments)
        if instruction_name == 'JUMPIFNEQ':
            jumpifneq(arguments)
        if instruction_name == 'EXIT':
            exit(arguments)
        if instruction_name == 'DPRINT':
            pass
        if instruction_name == 'BREAK':
            pass
        if instruction_name =='CLEARS':
            clears(arguments)
        if instruction_name =='ADDS':
            adds(arguments)
        if instruction_name =='SUBS':
            subs(arguments)
        if instruction_name =='MULS':
            muls(arguments)
        if instruction_name =='IDIVS':
            idivs(arguments)
        if instruction_name =='ANDS':
            ands(arguments)
        if instruction_name =='ORS':
            ors(arguments)
        if instruction_name =='NOTS':
            nots(arguments)

if __name__ == '__main__':
    main()