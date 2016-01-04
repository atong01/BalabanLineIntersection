Optimal Algorithm for Intersections of a Set of Segments
========================================================

.. _link to tree slides: http://cs.tufts.edu/~atong01/slides/index.html

.. _Problem_Statement:

Problem Statement
-----------------
**Given a set of line segments in 2D what is the most efficient way to find all
of the intersections between those segments?**

This problem is useful in a number of areas of computer graphics and as a
building block to more useful problems in computational geometry such as whether
a polygon or polyline can be considered "simple".

Overview
--------

The object of this site is to present in an easy to understand way a few algorithms
used for 2D segment intersection problems. This site will explore in particular a
few algorithms of interest:

#. The naive algorithm :math:`O(n^2)`
#. The standard algorithm (Bentley-Ottman) :math:`O((n+k)log(n))`
#. Balaban’s optimal algorithm utilizing :math:`O(nlog(n) + k)` time and :math:`O(n)` space.

Here n is the number of segments and k is the number of intersections between
segments. :math:`k = O(n^2)`.

There are other algorithms that perform in :math:`O(nlogn + k)` time, but Balaban's
algorithm is the first to perform deterministically in optimal space and time.

Links to the original papers can be found in the References section of this site.
They contain more complete explanations of the overviews found here.

The Naive Algorithm
-------------------

The simplest algorithm to enumerate all intersections between segments in a set
is to check every segment against every other segment for an intersection. Since
an intersection between two segments can be checked in :math:`O(1)` time, and there
are :math:`\binom{n}{2}` possibilities to check, this algorithm runs in :math:`O(n^2)` time.

The Bentley-Ottman Algorithm
----------------------------

First, we present an overview of the standard algorithm, the Bentley-Ottmann also
known as the sweep-line algorithm. This is the standard algorithm because it is
very easy to implement and often performs well enough, in the case of a close to
linear k, i.e. when :math:`k = O(n)` it performs as well as the optimal.

The overall strategy behind the Bentley-Ottmann algorithm is to sweep a vertical sweep 
line across the plane, maintaining the current vertical order of all lines
intersecting our sweep line. This allows us to process “events” as they come up
in the sweep line, inserting, swapping, or deleting elements depending on the
type of event encountered.

The Bentley-Ottmann algorithm can be described in the following steps on a set of segments S:

#. Initialize an event queue Q containing x coordinates of all endpoints in S in sorted order :math:`O(nlogn)`
#. Initialize an empty BST (Binary Search Tree) T that contains all line segments that intersect the sweep line sorted by their y coordinate. 
#. While Q is not empty, process the event E of minimum x value

    #. If E is a start point (the left endpoint of a segment), insert the associated segment into T, check segments
       immediately above and below our segment, if they cross our segment then add that event to Q.
    #. If E is an end point (the right endpoint of a segment), remove the associated line from T, check segments
       immediately above and below our line, if they cross each other then add that event to Q.
    #. If E is an intersection, then check for intersections in its neighbors in
       the tree T, adding relevant intersections to Q.

.. TODO:: Step 3

For more detail see the `Bentley-Ottman Algorithm Wiki <https://en.wikipedia.org/wiki/Bentley–Ottmann_algorithm>`_.

Resource Analysis
+++++++++++++++++
Event Q size O(n+k), T size O(n), insert, delete, swap O(logn) per event, adding
intersection events O(logn) per event. Total time O((n+k)logn).

For a more complete analysis of the standard algorithms please visit Dan Sunday's
site on `Intersections of a set of segments <http://geomalgorithms.com/a09-_intersect-3.html>`_.

The Balaban Algorithm
---------------------

This algorithm still uses a form of the sweep line used in the Bentley-Ottman Algorithm.
However, instead of slicing the horizontal event space
in a linear fashon, we instead slice the event space into a binary tree
of strips. Where each strip is split into two equally sized strips.
This allows us to incorporate knowledge of the two children vertical
strips into the current strip, specifically to make an :math:`O(logn)` step into
a :math:`O(1)` step.

.. TODO:: clearer

**The first thing we do is normalize X coordinates.** Since we are only concerned
if two segments intersect, and not where in the plane they intersect,
then as a first step we can normalize the X end points to integers in the range
0...2N.

A demonstration can be found `here <slides/index.html>`_.

However, the most important concept to understand this algorithm is the usefulness of a
staircase (picture below).

.. figure:: images/stairs.png
    :width: 1024px
    :align: center

    Figure 1: There are three complete staircases colorcoded in the figure above (red, blue, green).
    These are staircases because they do not intersect within this strip. They are complete because 
    we cannot add another non-intersecting segment to the set. These concepts are defined more
    formally below.

.. There are always many possible staircases, however these are the only 3 complete
    staircases for this particular set of segments in this strip. All other possible
    sets of segments either intersect, or can add another non-self intersecting segment
    to the set, and are therefore either incomplete, or invalid staircases.

Preliminaries
+++++++++++++
First a couple of definitions and notational elements:

.. _strip:

strip :math:`\langle b,e\rangle`
    A strip represents a vertical strip from a beginning vertical line at :math:`x=b`
    to an ending vertical line at :math:`x=e`

.. _span:

span
    A segment *s* is said to span a strip_ :math:`\langle b,e\rangle` if *s* intersects both
    lines :math:`x=b` and :math:`x=e`

staircase :math:`\langle b,e\rangle`
    A staircase is a sorted set of non-intersecting segments that span_ the strip_ :math:`\langle b,e\rangle`.
    By this definition, any single segment is a staircase. Or any group of non-intersecting segements.

..    This is useful as within the strip, for any line segment has a point in a particular stair
    we can find the set of stairs that it intersects with as a range counting problem
    which is accomplished :math:`O(log(n))` time.

.. _complete staircase:

complete staircase 
    A staircase is considered complete, if we cannot add any more non-intersecting
    segments to the set. More formally, A staircase is complete relative to some
    set *S* if each segment of *S* either
    does not span the strip_ :math:`\langle b, e\rangle` or intersects one of the
    stairs of the staircase. This is in some ways a more useful concept.

.. _SearchInStrip:

Finding Intersections In A Strip
++++++++++++++++++++++++++++++++

One way to attack the problem of finding intersections in a strip is to define
the problem recursively. The instead of trying to find all intersections between
segments in a set (lets call it S). We can partition S into two subsets, :math:`S_1`,
and :math:`S_2`. We can conclude that finding all intersections of segments in set S,
denoted Int(S), is the same as finding all intersections between segments of :math:`S_1`, 
intersections between segmenets of :math:`S_2`, and intersections between segments
of :math:`S_1` and :math:`S_2`. In this way we can break down the problem of finding
intersections between segmenets in a single set, into multiple smaller problems.

For this algorithm we will use a vary particular partition of our set S of segments
in a strip. Specifically, if we split out a set Q, a complete staircase with
respect to S, and have the leftovers of the partition in a set :math:`S_p`, then
the problem is even more simple than the general case, as there are no intersections
between segments in the set Q, by the definition of a `complete staircase_`. This
leaves us with a way to split the problem of finding the intersections of segments
in a set S into three parts, finding a complete staircase Q, and leftovers :math:`S_p`,
finding intersections between Q and :math:`S_p`, and finding intersections between
segments in :math:`S_p`.

For a strip with segments S:
    #. find a complete staircase Q (split)
    #. find intersections between Q and :math:`S_p = S - Q`
    #. find intersections between segments in :math:`S_p` (Recurse)

More formally,

Where L is ordered by intersection with the left side of the strip :math:`x=b`,
R is ordered by the right side of the strip, and b, e are the beginning and
ending x coordinates of the strip.

.. literalinclude:: SearchInStrip.py
    :linenos:

1. Finding A Complete Staircase
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To find the complete staircase we iterate through the entire set S sorted by left
endpoint, and appending any segment that does not intersect the previous staircase segment.

.. literalinclude:: Split.py
    :linenos:

By inspection of the function it is easy to conclude that split runs in :math:`O(|L|)` time and space.

2. Finding The Intersections Between Q and :math:`S_p`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Because Q is ordered, and none of its segments intersect, figuring out whether any
segment in S_p intersects any segment in Q is easy. For any segment **s** we check the stairs
in Q above and below **s**. We continue in this fashion, checking stairs above and
below until the first stair that does not intersect our segment. 

The function findStaircaseIntersections runs in :math:`O(|S| + |Int_{\langle b,e \rangle}(S)|)` time,
as for each line in S we do a constant number (2) intersection checks + the number
of successful checks.

3. Find Intersections Between Segments in :math:`S_p`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To find the intersections between segments in :math:`S_p`, we simply recurse using
SearchInStrip until there are no lines left left.

If all segments span a single strip, finding intersections between segments in :math:`S_p`
would be easy, the above algorithm would be sufficient. However, we cannot assume
all segments are spanning. Therefore, we present a Tree Search algorithm that deals
with line end points with a binary search until all segments span the strip.

A First Attempt
+++++++++++++++

.. _version 1:

Tree Search(S, b, e)
^^^^^^^^^^^^^^^^^^^^

    1. If all segments cross the Strip :math:`\langle b, e\rangle`, then perform a SearchInStrip_ operation, and return
    2. Split S into a staircase Q, and a remainder :math:`S_p`
    3. Find intersections between Q and :math:`S_p`
    4. find the median endpoint :math:`c` (because we normalized the x coordinates, the median is the mean)
    5. Perform a TreeSearch on both sides, strips :math:`\langle b,c\rangle`, :math:`\langle c,e\rangle`

c is a new point in the middle of b and e, which allows for a binary search
of the horizontal space.

Note that step 2 is inefficient, since in general S is unordered, and so finding
a staircase Q takes too long.
Therefore for efficient staircase finding of S, we present a second attempt at
Tree Search, one with a new representation of S.

Note that with each successive recursing of tree search the number of segments shrinks
by at least the size of the staircase for each level. This is important later
in the overall time complexity of the algorithm because if the number of segments
did not shrink then we would be performing n SearchInStrip operations.

.. TODO:: what happens if all staircases are constant size?

A Second Attempt
++++++++++++++++

To speed up the algorithm we view a set of lines in regards to a strip_ as a 
union of three different sets. We say that a set **S** in reference to a strip 
:math:`\langle b,e\rangle` is the union of three sets, L and R are redefined more
broadly in the general case as:

    - L -- All segments intersecting the line :math:`x=b` in sorted order
    - R -- All segments intersecting the line :math:`x=e` in sorted order
    - I -- The set of all segments that do not span the strip :math:`\langle b,e\rangle`
      unordered.

.. figure:: images/lri.png
    :width: 1024px
    :align: center

    Figure 2: Red segments are members of L, Green segments are members of I,
    Blue segmenets are members of R, and Purple segments are members of L and R.

This representation is easy to create in :math:`O(|S|log|S|)` time. As it is an
:math:`O(|S|)` Operation to find those lines in each set and an :math:`O(|S|log|S|)`
operation to sort sets L, R.

Our new tree search uses this concept, taking sets L, I, and S, and generating a
set R, and all the intersections with the staircase generated at that level.

Tree Search
^^^^^^^^^^^

Given our new representation for set S all we have to do is modify the recursion in step 5 of `version 1`_, and the stair intersection finding in step 3 of `version 1`_.

Step 5:
    a. Split the segments of I into :math:`I_{ls}`, :math:`I_{rs}`, and :math:`R_{ls}`
    b. TreeSearch on the left side to get the rest of :math:`R_{ls}`
    c. Insert or delete the one segment that changed on the line :math:`x=c` to get :math:`L_{rs}` (assuming no segments end/begin on the same x coordinate)
    d. Perform a TreeSearch on strip :math:`\langle c,e\rangle`, the right side to get :math:`R_{rs}`

Step 3:
    e. Find intersections between Q and :math:`L_{ls}`
    f. Find intersections between Q and :math:`R_{rs}`
    g. Find location of each segment in I in the stairs
    h. Find intersections between Q and I

The recursion step gets a little more complicated because we must figure out
the new assignments for L, I, and R for each side of the recursion. We denote the
L set for the left side of the strip :math:`\langle b,c\rangle` as :math:`L_{ls}`, and
for the right side of the strip as :math:`L_{rs}`.

.. figure:: images/lir_left.png
    :width: 512px
   
    Figure 3: Shows the new assignments for :math:`L_{ls}`, :math:`R_{ls}`, and :math:`I_{ls}`.

.. figure:: images/lir_right.png
    :width: 512px

    Figure 4: Shows the new assignments for :math:`L_{rs}`, :math:`R_{rs}`, and :math:`I_{rs}`.

Looking closely, we have effectively accomplished the same operation at each node
of the tree only with our new representation of the set S. However, this algorithm
runs more efficiently, in fact it runs in :math:`O(n log^2(n) + k)` where n is the
number of segments in the original set S and k is the number of intersections between
segments in S. We will not prove rigourously why this is the case here, please see
Balaban's original paper for rigourous proof [1]_.

.. TODO:: where specifically???

The slow step is step 10, which takes up to :math:`O(logn)` time
for each segment in I at each node, the final algorithm improves
this step to an :math:`O(1)` operation, which improves the overall algorithm
time complexity to :math:`O(n logn + k)`.

The Optimal Algorithm
+++++++++++++++++++++

In the last algorithm to find the intersections between the set I and the current
staircase, we first have to locate the starting location of each of the segments
of I with a binary search, which then allows a :math:`O(1 + #Intersections)` per
segment search for stair intersections. 

For the optimal algorithm to locate the stair location, denoted *Loc(s)* for segment
s, for a given strip :math:`\langle b,e\rangle`, i.e. which two stairs the left
endpoint of segment *s* lies between, we can incorporate knowledge of the same
segments location in a slightly different but similar set of stairs, namely the
stairs of either the left or right strip of the current strip.

The idea here is to use stair location of the child nodes of the current node
to locate the segments in I. Specifically, by including every 4th stair in the
father node's staircase in the current staircase. Intuitively, this increases
the current staircase size by a constant factor, which won't change the time 
complexities of any of the sub processes. 

We denote the father staircase of staircase :math:`Q` as :math:`Q_{ft}`.

.. figure:: images/optimal.png
    :width: 1024px
    :align: center

    Figure 5: Depicts the process of locating segment I in the father node ft 
    given that we know its location in the child node (between stairs A and B).

By including every 4th stair from the father node in the current stair case, then
we can eliminate the case above, so that there are a maximum of four possible stair
locations in the father staircase once we know the location in the child staircase.

Conclusions
+++++++++++

By making this small change in the way staircases are used, we lower the overall
time complexity to :math:`O(nlogn + k)`, our target complexity. 

References
----------
.. [#] I.J. Balaban, "An Optimal Algorithm  for Finding Segment Intersections", Proc. 11-th Ann. ACM Sympos. Comp. Geom., 211-219 (1995)
.. [#] Bernard Chazelle & Herbert  Edelsbrunner, "An Optimal Algorithm for Intersecting Line Segments in the  Plane", J. ACM 39, 1-54 (1992)
.. [#] Brad Appleton, C++ code for an AVL balanced Tree, see: www.bradapp.com, oopweb.com/Algorithms/Documents/AvlTrees/VolumeFrames.html, www.bradapp.com/ftp/src/libs/C++/AvlTrees.html (1997)
