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
a polygon or poly line can be considered "simple".

Overview
--------

The object of this site is to present in an easy to understand way a few algorithms
used for 2D line intersection problems. This site will explore in particular a
few algorithms of interest:

#. The naive algorithm :math:`O(n^2)`
#. The standard algorithm :math:`O((n+k)log(n))`
#. Balaban’s optimal algorithm utilizing :math:`O(nlog(n) + k)` time and :math:`O(n)` space.

Links to the original papers can be found in the References section of this site.
They contain more complete explanations of the overviews found here.

The Bentley-Ottman Algorithm
----------------------------

First, we present an overview of the standard algorithm, the Bentley-Ottmann also
known as the sweep-line algorithm. This is the standard algorithm because it is
very easy to implement and often performs well enough, in the case of a close to
linear k, it performs algorithmically as well as the optimal.

The overall strategy behind the Bentley-Ottmann algorithm is to sweep a vertical
line across the plane, maintaining the current vertical order of all lines
intersecting our sweep line. This allows us to process “events” as they come up
in the sweep line, inserting, swapping, or deleting elements depending on the
type of event encountered.

The Bentley-Ottmann algorithm can be described in the following steps:

#. Initialize an event queue Q containing all x end points of lines in the set S
#. Initialize an empty BST T that contains in vertical sorted order all line segments that intersect the sweep line.
#. While Q is not empty, process the even E of minimum x value

    #. If E is a start point, insert the associated line into T, check segments
       immediately above and below our line, if they cross our line then add that event to Q.
    #. If E is an end point, remove the associated line from T, check segments
       immediately above and below our line, if they cross each other then add that event to Q.
    #. If E is an intersection, then check for intersections in its neighbors in
       the tree T, adding relevant intersections to Q.

Resource Analysis
+++++++++++++++++
Event Q size O(n+k), T size O(n), insert, delete, swap O(logn) per event, adding
intersection events O(logn) per event. Total time O((n+k)logn).

For a more complete analysis of the standard algorithms please visit Dan Sunday's
site on `Intersections of a set of segments <http://geomalgorithms.com/a09-_intersect-3.html>`_.

The Balaban Algorithm
---------------------
This algorithm still uses a form of the sweep line used in the Balaban algorithm.
However, instead of slicing the horizontal event space into unit length pieces
in a linear fashon, we instead slice the event space into strips in a binary tree
of strips.

However, the most important concept to understand this algorithm is the usefulness of a
staircase (defined below). With the concept of a staircase, the Balaban line 
intersection algorithm boils down into the following.

For a strip between two vertical lines
    - find a staircase Q and leftovers S
    - find intersections between Q and S
    - recurse on two smaller strips to find intersections between segments in S

Intuitively this works if we realize two things. 
    1. It is very easy to find the intersections between a staircase and a set of
       lines.
    2. By seperating out staircases we are greatly reducing the amount of work
       necessary in lower levels of the recursion.

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
    This is useful as within the strip, for any line segment has a point in a particular stair
    we can find the set of stairs that it intersects with as a range counting problem
    which is accomplished :math:`O(log(n))` time.

    **IMAGE HERE**

.. _complete_staircase:

complete staircase 
    A staircase is complete relative to some set *S* if each segment of *S* either
    does not span the strip_ :math:`\langle b, e\rangle` or intersects one of the
    stairs of the staircase.

The function findStaircaseIntersections runs in :math:`O(|L| + |Int_{\langle b,e \rangle}(L)|)` time,
as for each line in L we do a contant number (2) intersection checks + the number
of successful checks.

.. should probably remove this code, make it reference section or something

.. literalinclude:: Split.py
    :linenos:

This function splits a set ordered by intersecton with line b (or e for that matter)
into a complete_staircase_ Q and a remaining set of lines L_p (L prime). By inspection
of the function it is easy to conclude that split runs in :math:`O(|L|)` time and space.

.. figure:: images/stairs.png
    :width: 1024px
    :align: center

    Figure 1: There are three possible complete staircases colorcoded in the figure above.
    There are always many possible staircases, however these are the only 3 complete
    staircases for this particular set of segments in this strip. All other possible
    sets of segments either intersect, or can add another non-self intersecting segment
    to the set, and are therefore either incomplete, or invalid staircases.

**IMAGE HERE Split process**

.. _SearchInStrip:

.. literalinclude:: SearchInStrip.py
    :linenos:

This function, given a set of line segments that span_ the strip_ b, e, finds
all of the intersections between segments that occur in the strip, and as a
useful addition, finds the ordering of the segments of the set on the right
side of the strip, i.e. returns set R where R contains all segments of L ordered
by vertical intersection with the line :math:`x=e`. Below is an example of the
execution of the function SearchInStrip. This reordering of the lines is important
so that we are able to perform the same operation on the next strip to the right
of our current strip, as ordering the rightside of our strip is equivalent to
ordering the left side of the next strip.

.. figure:: images/figure3.png
    :width: 1024px
    :align: center

    Figure 3: This figure is copied from Balaban's paper [1]_. It shows the process
    followed by the search in strip function on a set of 8 segments. Given a set of
    segments sorted by their intersection with the left side of the strip **L**
    we calculate a complete staircase **Q**.

**IMAGE HERE SEARCH INSTRIP**

The next question is how fast can we perform this procedure SearchInStrip_?
It turns out that this procedure will, for a given set of lines *L* ordered by
intersection with the line :math:`x=b`, run in :math:`O(|L| + |Int_{\langle b,e \rangle}(L)|)`
time.

However, the problem with SearchInStrip_ is that it only works if all segments
span the strip. In fact if all segments spanned all strips, (a.k.a. all segments were lines)
to solve the original Problem_Statement_ we could simply sort all of the line
segments by their slope (sort at :math:`x=-\infty`) and use a single SearchInStrip_
call.

Therefore for our algorithm to work with segments in general, we use another
function which we will call TreeSearch. That deals with strips where adjacent
strips either add or remove one line segment. This works in general as we can
recursively split into strips that with 1/2 as many line beginnings and endings
using the fact that W.L.O.G we can relabel the *x* coordinates of the line
segments to be integers in the range 1...2N. We can then split down until each strip
is of size 1, where :math:`e-b = 1` in the new relabeled *x* coordinate system. 

Therefore we present a first version of tree search. 

A First Attempt
+++++++++++++++

.. literalinclude:: TreeSearch.py
    :linenos:

Tree Search
^^^^^^^^^^^

TreeSearch(S, b, e)

    1. If all segments cross the Strip, then perform a SearchInStrip_ operation, and return
    2. Split S into a staircase Q, and a remainder :math:`S_p`
    3. Find intersections between Q and :math:`S_p`
    4. find the median endpoint :math:`c`
    5. Perform a TreeSearch on both sides, strips :math:`\langle b,c\rangle`, :math:`\langle c,e\rangle`

While this algorithm will find all the intersections, it does not find them very
efficiently. Step 2, since S is an unordered set, we cannot complete efficiently.
Therefore for efficient staircase finding of S, we present a second attempt at
Tree Search, one with a new representation of S.

Note that with each successive level of tree search the number of lines shrinks
by at least the size of the staircase for each level. This is important later
in the overall time complexity of the algorithm.

A Second Attempt
++++++++++++++++

To speed up the algorithm we view a set of lines in regards to a strip_ as a 
union of three different sets. We say that a set **S** in reference to a strip 
:math:`\langle b,e\rangle` is the union of three sets

    - L -- All segments intersecting the line :math:`x=b` in sorted order
    - R -- All segments intersecting the line :math:`x=e` in sorted order
    - I -- The set of all segments that do not span the strip :math:`\langle b,e\rangle`
      unordered.

    **IMAGE HERE EXAMPLE OF L R I**

This representation is easy to create in :math:`O(|S|log|S|)` time. As it is an
:math:`O(|S|)` Operation to find those lines in each set and an :math:`O(|S|log|S|)`
peration to sort sets L, R.

Our new tree search uses this concept of a segment set instead, taking a sets 
L, I, and S, and generating a set R, and all the intersections with the staircase
generated at that level.

Tree Search
^^^^^^^^^^^

.. literalinclude:: TreeSearchv2.py
    :linenos:

TreeSearch(S, b, e)

    1. If all segments cross the Strip, then perform a SearchInStrip_ operation, and return
    2. Split S into a staircase Q, and a remainder :math:`L_p`, note that the staircase must span :math:`\langle b,e\rangle`, but the remainder of L does not
    3. Find intersections between Q and :math:`L_p`
    4. find the median endpoint :math:`c`
    5. Split the segments of I into :math:`I_{ls}` and :math:`I_{rs}`
    6. TreeSearch on the left side
    7. Insert or delete the one segment that changed on the line C to get :math:`L_{rs}`
    8. Perform a TreeSearch on strip :math:`\langle c,e\rangle`, the right side
    9. Find intersections between Q and :math:`R_{rs}`
    10. Find Location of left end point for each segment in I in the stairs
    11. Find intersections between Q and I
    12. Find the set R using knowledge about the child node's R and the intersections of L

**IMAGE HERE**

This algorithm uses the concepts from the last version, only it takes into account
a faster representation of the set S, which makes the particulars more complicated.
Looking closely, we have effectively accomplished the same operation at each node
of the tree only with our new representation of the set S. However, this algorithm
runs more efficiently, in fact it runs in :math:`O(n log^2(n))` where n is the
number of segments in the original set S. The only slow step is step 10.
Which takes up to :math:`O(logn)` time at each node, the final algorithm improves
this step to an :math:`O(1)` operation, which improves the overall algorithm
time complexity to :math:`O(n logn)`.

The Optimal Algorithm
+++++++++++++++++++++

In the last algorithm to find the intersections between the set I and the current
staircase, we first have to locate the starting location of each of the segments
of I with a binary search, which then allows a :math:`O(1 + #Intersections)` per
segment search for stair intersections. 

The idea here is to use stair location of the child nodes of the current node
to locate the segments in I. Specifically, by including every 4th stair in the
father node's staircase in the current staircase. Intuitively, this increases
the current staircase size by a constant factor, which won't change the time 
complexities of any of the sub processes'. 

**IMAGE HERE**


References
----------
.. [#] I.J. Balaban, "An Optimal Algorithm  for Finding Segment Intersections", Proc. 11-th Ann. ACM Sympos. Comp. Geom., 211-219 (1995)
.. [#] Bernard Chazelle & Herbert  Edelsbrunner, "An Optimal Algorithm for Intersecting Line Segments in the  Plane", J. ACM 39, 1-54 (1992)
.. [#] Brad Appleton, C++ code for an AVL balanced Tree, see: www.bradapp.com, oopweb.com/Algorithms/Documents/AvlTrees/VolumeFrames.html, www.bradapp.com/ftp/src/libs/C++/AvlTrees.html (1997)

* :ref:`search`

