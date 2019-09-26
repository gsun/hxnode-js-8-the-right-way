import js.node.Fs;
import js.Node.process;
class ReadStream {
    static function main() {
        Fs.createReadStream(Sys.args()[0])
        .on('data', (chunk) -> process.stdout.write(chunk))
        .on('error', (err) -> process.stderr.write('Error: ${err.message}\n'));
    }
}