import dn.Rand;
import hxd.System;
import Node;

class Board {

    public var g = new Array();
    public var start = {
        x: 1,
        y: 1
    }
    public var end = {
        x: 30,
        y: 30
    }

    public var height: Int;
    public var width: Int;

    private var open = new Array();  
    private var closed = new Array();

    public function new(height,width) {
        for (i in 0 ... height) {
            g.push(new Array());
            for (j in 0 ... width) {
                g[i][j] = new Node(i,j,NodeState.Undiscovered);

                if (Random.int(0,10) < 6)
                    g[i][j].state = NodeState.Impassable;
            }
        }

        this.height = height;
        this.width = width;

        g[start.x][start.x].state = NodeState.Undiscovered;
        g[end.x][end.x].state = NodeState.Undiscovered;


        var first = g[start.x][start.y];
        first.gScore = 0;
        first.hScore = 0;
        open.push(first);
    }

    public function update() {
        getPath();
    }

    private function getNeighbors(x, y) {
        var parent = g[x][y];
        var arr = new Array();

        for (i in -1 ... 2) {
            for (j in -1 ... 2) {
                if (i == 0 && j == 0)
                    continue;
                var checkX = i+x;
                var checkY = j+y;
                if (
                    checkX >= 0 && checkX < width &&
                    checkY >= 0 && checkY < height &&
                    (g[checkX][checkY].state == NodeState.Undiscovered || g[checkX][checkY].state == NodeState.Open)
                ) {
                    var node: Node = g[checkX][checkY];
                    var distance = dist(x,y,node.x,node.y);
                    var parentGScore = (parent != null) ? parent.gScore : 0;
                    var newGScore = Math.floor(parentGScore + distance);
                    var newHScore= Math.floor(dist(node.x,node.y,end.x,end.y) * 2);

                    if ((newHScore + newGScore) < node.fScore()) {
                        node.gScore = newGScore;
                        node.hScore = newHScore;
                        node.parent = parent;
                    }

                    arr.push(node);
                }
            }
        }
        return arr;
    }

    private function dist(a,b,c,d) {
        return Math.sqrt(
            Math.pow(c - a,2) +
            Math.pow(d - b,2)
        ) * 10;
    }

    private function getBestNode(open: Array<Node>) {
        var best: Node = null;
        best = open[0];
        for (node in open) {
            if (
                (
                    node.fScore() == best.fScore() &&
                    node.hScore < best.hScore
                ) || 
                node.fScore() < best.fScore()
            ) {
                best = node;
            }
        }
        open.remove(best);
        return best;
    }

    var lastUpdate = 0;  
    var found = false;
    var center: Node;
    var totalDistance = 0;
    private function getPath() {

        // Every 2 seconds.
        var secondsNow = Math.floor(Date.now().getTime() * 100);
        if (!found && open.length > 0 && secondsNow != lastUpdate) {
            lastUpdate = secondsNow;

            center = getBestNode(open);

            center.state = NodeState.Closed;
            closed.push(center);
            var neighbors = getNeighbors(center.x,center.y);

            // FOUND
            for (node in neighbors) {
                if (node.x == end.x && node.y == end.y) {
                    // node.parent = center;
                    center = node;
                    found = true;
                    return;
                }
                node.state = NodeState.Open;
                if (!open.contains(node))
                    open.push(node);
            }

        } else {
            if (center != null) {
                center.state = NodeState.Tracing;
                if (center.parent != null)
                    totalDistance += Math.floor(dist(center.x,center.y,center.parent.x,center.parent.y));
                center = center.parent;
                trace(totalDistance);
            }
        }
    }
}