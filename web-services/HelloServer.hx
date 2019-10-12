import js.npm.Express;
import js.Node.console;

class HelloServer {
    static function main() {
        var app = new Express();
        
        app.get('/hello/:name', (req, res) -> {
            res.status(200).json({'hello': req.params.name});
        });
        
        app.listen(60701, () -> console.log('Ready.'));
    }
}