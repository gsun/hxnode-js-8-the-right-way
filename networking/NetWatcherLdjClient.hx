import js.node.Net;
class NetWatcherLdjClient {
    static function main() {
        var netClient = Net.connect(60300);
        var ldjClient = new LdjClient(netClient);
        ldjClient.on('message', (message) -> {
            if (message.type == 'watching') {
                trace('Now watching: ${message.file}');
            } else if (message.type == 'changed') {
                trace('File changed: ${message.timestamp}');
            } else {
                trace('Unrecognized message : ${message}');
            }
        });
    }
}