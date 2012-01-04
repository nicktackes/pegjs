// parses model navigation with dot notation (example customer.address.zip)

start
  = model

model
  = left:compoundmodelpart "." right:modelpart { return left +'.' + right; }
  / compoundmodelpart

compoundmodelpart
  = left:modelpart "." right:modelpart { return left +'.'+ right; }
  / modelpart

modelpart "modelpart"
  = modelpart:[a-zA-Z0-9_]+ { return modelpart.join(""); }



  // this adds the binding syntax around a model navigation
  start
  = binding

binding
= "@{" left:root right:model "}" {return left + right;}
/ "@{"  model:model "}"  { return model; }

root
  = ".." {return "..";}

model
  = left:compoundmodelpart "." right:modelpart { return left +'.' + right; }
  / compoundmodelpart

compoundmodelpart
  = left:modelpart "." right:modelpart { return left +'.'+ right; }
  / modelpart

modelpart "modelpart"
  = modelpart:[a-zA-Z0-9_]+ { return modelpart.join(""); }



// added in relative window or autoup support
start
  = binding

binding
= "@{" relbased:relbased "}" {return relbased;}

relbased
= left:autoup right:model {return left + right;}
/ left:window right:model {return left + right;}
/ model:model  { return model; }

window
 = "/" {return "/"}

autoup
  = ".." {return "..";}

model
  = left:compoundmodelpart "." right:modelpart { return left +'.' + right; }
  / compoundmodelpart

compoundmodelpart
  = left:modelpart "." right:modelpart { return left +'.'+ right; }
  / modelpart

modelpart "modelpart"
  = modelpart:[a-zA-Z0-9_]+ { return modelpart.join(""); }


// added inverse support
start
  = binding

binding
= "@{" left:inverse right:relbased "}" {return left + right;}
/ "@{" relbased:relbased "}" {return relbased;}

relbased
= left:autoup right:model {return left + right;}
/ left:window right:model {return left + right;}
/ model:model  { return model; }

inverse
 = "!" {return "!"}

window
 = "/" {return "/"}

autoup
  = ".." {return "..";}

model
  = left:compoundmodelpart "." right:modelpart { return left +'.' + right; }
  / compoundmodelpart

compoundmodelpart
  = left:modelpart "." right:modelpart { return left +'.'+ right; }
  / modelpart

modelpart "modelpart"
  = modelpart:[a-zA-Z0-9_]+ { return modelpart.join(""); }


// added in support for char strings
start
  = suffixed

suffixed
= left:binding right:chars {return left + right;}
/ prefixed

prefixed
= left:chars right:binding {return left + right;}
/ binding

binding
= "@{" left:inverse right:relbased "}" {return left + right;}
/ "@{" relbased:relbased "}" {return relbased;}
/ chars
/ ""

relbased
= left:autoup right:model {return left + right;}
/ left:window right:model {return left + right;}
/ model:model  { return model; }


model
  = left:compoundmodelpart "." right:modelpart { return left +'.' + right; }
  / compoundmodelpart

compoundmodelpart
  = left:modelpart "." right:modelpart { return left +'.'+ right; }
  / modelpart

modelpart "modelpart"
  = modelpart:[a-zA-Z0-9_]+ { return modelpart.join(""); }


inverse
 = "!" {return "!"}

window
 = "/" {return "/"}

autoup
  = ".." {return "..";}

chars
  = chars:char+ { return chars.join(""); }

char
  // In the original JSON grammar: "any-Unicode-character-except-"-or-\-or-control-character"
  = [^@{}"\\\0-\x1F\x7f]
  / '\\"'  { return '"';  }
  / "\\\\" { return "\\"; }
  / "\\/"  { return "/";  }
  / "\\b"  { return "\b"; }
  / "\\f"  { return "\f"; }
  / "\\n"  { return "\n"; }
  / "\\r"  { return "\r"; }
  / "\\t"  { return "\t"; }
  / "\\u" h1:hexDigit h2:hexDigit h3:hexDigit h4:hexDigit {
      return String.fromCharCode(parseInt("0x" + h1 + h2 + h3 + h4));
    }

hexDigit
  = [0-9a-fA-F]


/* ===== Whitespace ===== */

_ "whitespace"
  = whitespace*

// Whitespace is undefined in the original JSON grammar, so I assume a simple
// conventional definition consistent with ECMA-262, 5th ed.
whitespace
  = [ \t\n\r]