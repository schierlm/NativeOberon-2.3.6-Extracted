MODULE Hello;
	IMPORT Out;

	PROCEDURE World*;
	BEGIN
		Out.String("Hello, world!"); Out.Ln()
	END World;

END Hello.

0. Compile the program by setting the star marker into this text
    with F1 and middle click the command Compiler.Compile *

1. Middle click the command Hello.World
    (This displays the text "Hello, world!" in the System.Log Viewer).

2. Change the string in the program to "Here I am".

3. Compile the program as in step 0.

4. Middle click the command Hello.World
   (This displays the text "Hello, world!" again).

5. Middle click + left interclick the command Hello.World to load the new 
	version of module Hello (should display the new string).

6. Note that the generated output is an Oberon text that can be edited,
    stored or loaded exactly as this program text can be.
   
Hello.World

System.Free Hello ~
