import js.node.Fs;

class RdfToJson {
    static function main() {
        var pg132 = Fs.readFileSync('pg132.rdf', {encoding:'utf8'});
        var rdf = new ParseRdf(pg132);
        Sys.println(haxe.Json.stringify({ index: { _id: 'pg${rdf.id}' } }));
        Sys.println(haxe.Json.stringify(rdf, null, ' '));
    }
}