using System;

namespace Tastier {

public class Obj { // properties of declared symbol
   public string name; // its name
   public int kind;    // var, proc or scope
   public int type;    // its type if var (undef for proc)
   public int subcategory; // defines a scalar or array

   public int level;   // lexic level: 0 = global; >= 1 local
   public int adr;     // address (displacement) in scope
   public Obj next;    // ptr to next object in scope
   // for scopes
   public Obj outer;   // ptr to enclosing scope
   public Obj locals;  // ptr to locally declared objects
   public int nextAdr; // next free address in scope
   public bool initialised = false; // whether or not it has been initialised

   // for arrays
   public int lastIndex; // highest index for an array
   public int numParameters;     // the number of parameters a procedure has
}

public class SymbolTable {

   const int // object kinds
      var = 0, proc = 1, scope = 2, constant = 3;

   const int // types
      undef = 0, integer = 1, boolean = 2;

   const int // var sub-categories
      scalar = 0, array = 1; // more such as sets, etc

   public Obj topScope; // topmost procedure scope
   public int curLevel; // nesting level of current scope
   public Obj undefObj; // object node for erroneous symbols

   public bool mainPresent;

   Parser parser;

   public SymbolTable(Parser parser) {
      curLevel = -1;
      topScope = null;
      undefObj = new Obj();
      undefObj.name = "undef";
      undefObj.kind = var;
      undefObj.type = undef;
      undefObj.level = 0;
      undefObj.adr = 0;
      undefObj.next = null;
      this.parser = parser;
      mainPresent = false;
      undefObj.initialised = true;
      undefObj.subcategory = scalar;
      undefObj.lastIndex = -1;
      undefObj.numParameters = 0;
   }

// open new scope and make it the current scope (topScope)
   public void OpenScope() {
      Obj scop = new Obj();
      scop.name = "";
      scop.kind = scope;
      scop.outer = topScope;
      scop.locals = null;
      scop.nextAdr = 0;
      topScope = scop;
      curLevel++;
   }

// close current scope
   public void CloseScope() {
     Obj items = topScope.locals;

     int type, kind, lexicalLevel;
     string typeName, kindName, subcategoryName, lexicalLevelName;

     while ( items != null) {
       type = items.type;
       kind = items.kind;
       lexicalLevel = items.level;


       if(type == 0)
         typeName = "undef";
       else if(type == 1)
         typeName = "integer";
       else
         typeName = "boolean";

       if(kind == 0)
         kindName = "var";
       else if(kind == 1)
         kindName = "proc";
       else if(kind == 2)
         kindName = "scope";
       else
         kindName = "constant";

       if(lexicalLevel == 0)
         lexicalLevelName = "global";
       else
         lexicalLevelName = "local";

       if(items.subcategory == 0)
         subcategoryName = "Scalar";
       else
         subcategoryName = "Array";


       Console.WriteLine(";Name: {0}, Type: {1}, Kind: {2}, Sub-Category: {3}, Level: {4}, Init: {5}, Adr: {6} , Next Address: {7}", items.name, typeName, kindName, subcategoryName, lexicalLevelName, items.initialised, items.adr, items.nextAdr);

       items = items.next;
     }

     topScope = topScope.outer;
     curLevel--;
   }

// open new sub-scope and make it the current scope (topScope)
   public void OpenSubScope() {
   // lexic level remains unchanged
      Obj scop = new Obj();
      scop.name = "";
      scop.kind = scope;
      scop.outer = topScope;
      scop.locals = null;
   // next available address in stack frame remains unchanged
      scop.nextAdr = topScope.nextAdr;
      topScope = scop;
   }

   // close current sub-scope
      public void CloseSubScope() {
      // update next available address in enclosing scope
         topScope.outer.nextAdr = topScope.nextAdr;
      // lexic level remains unchanged
         topScope = topScope.outer;
      }

// create new object node in current scope
   public Obj NewObj(string name, int kind, int type, int subcategory, int lastIndex, int adr, int numParameters) {
      Obj p, last;
      Obj obj = new Obj();
      obj.name = name; obj.kind = kind;
      obj.type = type; obj.level = curLevel;
      obj.subcategory = subcategory;
      obj.lastIndex = lastIndex;
      obj.numParameters = numParameters;

      obj.next = null;
      p = topScope.locals; last = null;
      while (p != null) {
         if (p.name == name)
            parser.SemErr("name declared twice");
         last = p; p = p.next;
      }
      if (last == null)
         topScope.locals = obj; else last.next = obj;
      if (kind == var){
        if(adr <= -5)
          obj.adr = adr;
        else
          obj.adr = topScope.nextAdr++;
      }
      // declare address space for array's items
      if(obj.subcategory == array){
          obj.nextAdr += obj.lastIndex + 1;
      }

      return obj;
   }

// search for name in open scopes and return its object node
   public Obj Find(string name) {
      Obj obj, scope;
      scope = topScope;
      while (scope != null) { // for all open scopes
         obj = scope.locals;
         while (obj != null) { // for all objects in this scope
            if (obj.name == name) return obj;
            obj = obj.next;
         }
         scope = scope.outer;
      }
      parser.SemErr(name + " is undeclared");
      return undefObj;
   }

} // end SymbolTable

} // end namespace
