import js.node.Fs;
import js.Node.process;
class Cat {
    static function main() {
        Fs.createReadStream(Sys.args()[0]).pipe(process.stdout);
    }
}