import utest.Assert;
import js.node.Fs;

class TestCase1 extends utest.Test {
    
    //synchronous setup
    public function setup() {
    }

    function testRdfField() {
        var pg132 = Fs.readFileSync('pg132.rdf', {encoding:'utf8'});
        var rdf = new ParseRdf(pg132);
        Assert.equals(rdf.id, 132);
        Assert.equals(rdf.title, 'The Art of War');
        Assert.equals(rdf.authors.length, 2);
        Assert.equals(rdf.subjects.length, 2);
        Assert.contains('Sunzi, active 6th century B.C.', rdf.authors);
        Assert.contains('Giles, Lionel', rdf.authors);
        Assert.contains('Military art and science -- Early works to 1800', rdf.subjects);
        Assert.contains('War -- Early works to 1800', rdf.subjects);
    }
    
    public function teardown() {
    }

}

class TestAll {
    public static function main() {
        utest.UTest.run([new TestCase1()]);
    }
}