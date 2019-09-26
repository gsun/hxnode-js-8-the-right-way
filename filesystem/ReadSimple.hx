import js.node.Fs;
class ReadSimple {
    static function main() {
        Fs.readFile('target.txt', (err, data)-> {
            if (err != null) {
                throw err;
            }
            trace(data.toString());
        });
    }
}