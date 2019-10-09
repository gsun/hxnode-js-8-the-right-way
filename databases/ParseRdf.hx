@:jsRequire('./lib/parse-rdf')
extern class ParseRdf {
    @:selfCall
    public function new(t :String);
    
    public var id:Int;
    public var title:String;
    public var authors:Array<String>;
    public var subjects:Array<String>;
}