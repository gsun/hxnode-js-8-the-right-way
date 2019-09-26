import js.node.Fs;
class WriteSimple {
    static function main() {
        Fs.writeFile('target.txt', 'hello world', (err)-> {
            if (err != null) {
                throw err;
            }
            trace('File saved!');
        });
    }
}