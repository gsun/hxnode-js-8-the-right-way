import js.node.Fs;
import js.node.Path;
import js.lib.Error;

class RdfToBulk {
    static function main() {
        var args = Sys.args();
        if (args.length == 0) {
            throw new Error('Error: No directory specified.');
        }
        var dir = args[0];
        parse(dir);
    }

    static function parse(path:String) {
        try {
            if (sys.FileSystem.isDirectory(path)) {
                var entries = Fs.readdirSync(path);
                for (entry in entries) {
                  parse(path + '/' + entry);
                }
            } else {
                if (Path.extname(path) == ".rdf") {
                    var pg = Fs.readFileSync(path, {encoding:'utf8'});
                    var rdf = new ParseRdf(pg);
                    var j = haxe.Json.stringify(rdf, null, ' ');
                    trace(j);
                }
            }
        } catch (e:String) {
            trace(path + " " + e);
        }
    }
}