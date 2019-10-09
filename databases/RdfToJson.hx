import js.node.Fs;

class RdfToJson {
    static function main() {
        var pg132 = Fs.readFileSync('pg132.rdf', {encoding:'utf8'});
        var rdf = new ParseRdf(pg132);
        var j = haxe.Json.stringify(rdf, null, ' ');
        trace(j);
    }
}