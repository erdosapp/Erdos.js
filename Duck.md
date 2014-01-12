We need a SOulver like mode of Erdos. but Erdos.js can handle both. 

Right click on variable and drag it's values are changed.

I don't see why we cant mix and match grammars. Soulver grammar is applied against markdown paragraphs
Build up vars etc

Then a codeblock can be evaluated like magic.

Erdos.js is just a series of nodes that can be evaluated. Parser/Lexing and grammar turn stuff into our Erdos nodes.

ErdosPad can provided muptle styles of interface to this.

Soulver mode treats the entire document like a Markdown paragraph. Build up vars and expressions.

=> means output

We can think of it as layers;

- The interface; Soulver mode which outputs stuff to the side, or a graphical mode with slides for variables and connections. Or even a chart added.
- This all generates the Markup which is Markdown based and saved out to Dropbox.
- Markup is turned into an AST 
- Evaluator. Here is the key. Soulver mode is actually a simple evalutor. And so are the other modes.


So in a Soulver mode you'd have a Codemirror instance. You tokenize (the lexer) for the highlighiting.

And then each line gets passed into the parser that builds up an AST.

And then for each line we evaluate the AST using the Soulver evaluator.
The evaluator can be intelligent enough to know what to do. 

  - We also have a full on Evalautor server side that outputs things. In the future can 

The output my be display in the Sidebar but in the doucment it is just and output =>. Which simply means evaulate the line and put the output here. 

A graph.

graph(x^2+y^2=m^2) =>


Syntax for reactiveness looks like this.

    calories = cookies * 50  # This links calories to cookies

If you eat 10 cookies you consume 2000 calories

The parser really doesn't need to care in what order the variables get defined. So linking calories before cookies is available shouldn't be too big of a deal.

8 * cookies => 80

I think the easiest thing is to just assume we are going to write math on separate lines.
Then all we have to is find the => and turn that line into a math line.

Then a math block could be like:

=>
  calories = cookies * 50
  8 * cookies => output here
  cookies => 
=>

$5.00 for the bus * 2 trips => 

It also allows us to get clever and determine whether a line is a math line by picking up a number as the start or a known variable.

cookies = 50

Now how do we handle paragraphs though?

I cooked 7 cookies at Grandmas house. We baked them in the oven and then ate them. So, yeah there was actually dozens.
I ate like 30 cookies. But there was 17 cookies to start. 

This would warp the value of cookies all over the fucking place. So, I don't see a way to handle it any differently.

In a simple solver mode then we can treat every line specified with a number as needing an output or being a math line.
Actually, not really necessary parser just needs to get clever. 

We can easily split up the lexer and parsers.

Lexer is a just combination of the Markdown Lexer and a math lexer. When we hit a Math block we just transform ino

Note: Once we have the Markdown Lexer/Parser/Compiler (what is the appropriate name for the compiler?) built iA Writer clone.

We have overcomplicated a lot of this. We don't need to be worried about every context the parser is going to be used in. We only need to worry about math notepads. That is it. No HTML nesting etc, because they won't use it for HTML.

We can by default assume codeblocks are our language because what else would they be used for.

I have massively overcomplicated. Things. For the start all we need is a seperate lexer done with Regex for 
hgihlighting. And then a parser that detects a math line and strips out all the crap turning into somehting that cna 
be parsed. Then we can just pass each line into the Math parser build up the scope, maintain it and voila all is good. Separate the parsers and we are good to go.

Since we use getLine() and math expressions can be considered to be one one line we can simply do isMathLine() check
if it is pass to math parser.

Note: as far as one line goes we can add block parsing for math blocks later.