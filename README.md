# Assembly Text Editor

This is a simple text editor implemented in Assembly language using EMU8086. The editor allows basic text input, cursor movement, and file saving.

## Features

- **Text Input:** Allows you to type and edit text within an 80x25 character screen.
- **Cursor Movement:** Navigate text using arrow keys.
- **File Operations:** Save text to a file using the F5 key.

## Requirements

- **EMU8086:** An 8086 emulator to run and debug the Assembly code.

## Building and Running

1. **Install EMU8086:**
   Download and install EMU8086 from [EMU8086 official website](http://www.emu8086.com/).

2. **Load the Program:**
   Open EMU8086 and load the `text_editor.asm` file.

3. **Assemble and Run:**
   - Click on `Compile` to assemble the program.
   - Click on `Run` to execute the program in the emulator.

## Usage

1. **Start the Program:**
   Upon starting, the program will display a main menu with instructions.

2. **Text Input:**
   - Use the keyboard to type text into the editor.
   - Use arrow keys to navigate through the text.

3. **Cursor Movement:**
   - **Right Arrow:** Move the cursor right.
   - **Left Arrow:** Move the cursor left.
   - **Up Arrow:** Move the cursor up.
   - **Down Arrow:** Move the cursor down.

4. **Special Keys:**
   - **Enter:** Move to the next line.
   - **F5:** Save the current text to `file.txt`.
   - **Backspace:** Delete the character to the left of the cursor.
   - **ESC:** Exit the program.

## Troubleshooting

- **File Saving Issues:**
  If pressing the F5 key does not save the file:
  1. Verify the file path and permissions.
  2. Ensure EMU8086 is correctly mapping the F5 key to the `3F00h` scan code.
  3. Check for errors in the file handling code by reviewing the `saveToFile` procedure.

- **Key Mapping:**
  If the keys do not behave as expected, verify the scan codes used in the `read_char` procedure:
  - **ESC:** `27`
  - **Enter:** `1C0Dh`
  - **Arrow Keys:** `4800h` (Up), `4B00h` (Left), `4D00h` (Right), `5000h` (Down)
  - **F5:** `3F00h`
  - **Backspace:** `0E08h`

## Known Issues

- The file path is hardcoded as `file.txt`. For different paths, update the `filename` variable in the `.data` section of the Assembly code.

## Contributing

Feel free to submit issues or pull requests. Contributions are welcome!

