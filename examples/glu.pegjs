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