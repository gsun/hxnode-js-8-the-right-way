import js.node.Fs;
import js.Node.console;
import js.Node.console;

class RdfToJson {
    static function main() {
        var pg132 = Fs.readFileSync('pg132.rdf', {encoding:'utf8'});
        var rdf = new ParseRdf(pg132);
        console.log(haxe.Json.stringify({ index: { _id: 'pg${rdf.id}' } }));
        console.log(haxe.Json.stringify(rdf, null, ' '));
    }
}