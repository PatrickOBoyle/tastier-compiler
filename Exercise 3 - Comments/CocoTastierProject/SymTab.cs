using System;
using System.IO;

namespace Tastier {

public class Obj { // properties of declared symbol
   public string name; // its name
   public int kind;    // var, proc or scope
   public int type;    // its type if var (undef for proc)
   public int level;   // lexic level: 0 = global; >= 1 local
   public int adr;     // address (displacement) in scope
   public Obj next;    // ptr to next object in scope
   // for scopes
   public Obj outer;   // ptr to enclosing scope
   public Obj locals;  // ptr to locally declared objects
   public int nextAdr; // next free address in scope
}

public class SymbolTable {

   const int // object kinds
      var = 0, proc = 1, scope = 2;

   const int // types
      undef = 0, integer = 1, boolean = 2;

   public Obj topScope; // topmost procedure scope
   public int curLevel; // nesting level of current scope
   public Obj undefObj; // object node for erroneous symbols

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
      string typeName, kindName, lexicalLevelName;

      while ( items != null) {
        type = items.type;
        kind = items.kind;
        lexicalLevel = items.level;

        if(type == 0){
          typeName = "undef";
        }else if(type == 1){
          typeName = "integer";
        }else{
          typeName = "boolean";
        }

        if(kind == 0){
          kindName = "var";
        }else if(kind == 1){
          kindName = "proc";
        }else{
          kindName = "scope";
        }

        if(lexicalLevel == 0){
          lexicalLevelName = "global";
        }else{
          lexicalLevelName = "local";
        }

        Console.WriteLine("    ;Name: {0}, Type: {1}, Kind: {2}, Level: {3}", items.name, typeName, kindName, lexicalLevelName);

        items = items.next;
      }

    topScope = topScope.outer;
    curLevel--;
   }

// create new object node in current scope
   public Obj NewObj(string name, int kind, int type) {
      Obj p, last;
      Obj obj = new Obj();
      obj.name = name; obj.kind = kind;
      obj.type = type; obj.level = curLevel;
      obj.next = null;
      p = topScope.locals; last = null;
      while (p != null) {
         if (p.name == name)
            parser.SemErr("name declared twice");
         last = p; p = p.next;
      }
      if (last == null)
         topScope.locals = obj; else last.next = obj;
      if (kind == var)
         obj.adr = topScope.nextAdr++;
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
