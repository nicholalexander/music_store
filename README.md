Overview
--------
For this code test, you will be write a small program to help manage the inventory for a little record store. The program will be able to do 3 things: load delivery manifests from text files, search inventory, and remove items from the inventory. Each item in the inventory is described by the artist's name, the album title, the release year of the album, and the media format.


Interface
---------
The interface is composed of 3 commands:

**load_inventory**

 - Takes one parameter, the name of a file that contains a shipping manifest
 - The manifests come in two different formats, described below

**search_inventory**

 - Takes two parameters, a field name and a search substring
 - Returns the descriptions of matching items in the format specified below
 - Results are ordered ascending on the search field name, except for release year, which are descending
 - Each description includes an identifier unique to that inventory entry

**purchase**

 - Takes one parameter, the unique identifier


Characteristics of a Solution
-----------------------------
While this is a small exercise, we are looking to understand how you write and refine code. Your submission should be an example of what you consider to be production-quality. You will be graded on organization and style as well as correctness of solution.

As far as mechanics

 - Use Ruby and only the core Ruby libraries; don't use any gems, but the Ruby standard libraries (i.e. json, etc) are fine
 - Each command should be a separate script.

We will be evaluating your submission based on the following aspects

 - Functionality: It should work and adhere to this prompt
 - An appropriate level of design
 - Clarity of code
 - Maintainability and extensibility


Input Formats
-------------
The two formats are pipe-delimited and comma-separated.

The pipe-delimited format has the columns in the following order:

    Quanitity | Format | Release year | Artist | Title

The comma-separated format has one line per inventory item, with the columns in the following order:

    Artist,Title,Format,Release year

It's also worth noting that the venders aren't always the most reliable with their casing, etc. Make sure we don't end up with entries that differ only by casing of one of their fields, e.g. "Simon & Garfunkel" and "Simon & GARFunkle"


Output format
-------------
The results of a search should be printing in the format below with one line separating each record.

    Artist: <artist name>
    Album: <album title>
    Released: <release year>
    CD(<cd quantity>): <cd inventory identifier>
    Tape(<tape quantity>): <tape inventory identifier>
    Vinyl(<vinyl quantity>): <vinyl inventory identifier>


Example run
-----------
    $ ruby load_inventory.rb cd_sellers.csv
    $ ruby search_inventory.rb artist Nas
    Artist: Nas
    Album: Illmatic
    Released: 1994
    CD(2): <uid>
    Vinyl(1): <uid>
    $ ruby load_inventory.rb music_merchant.csv
    $ ruby search_inventory.rb album matic
    Artist: Nas
    Album: Illmatic
    Released: 1994
    Tape(2): <uid>
    Vinyl(1): <uid>

    Artist: Nas
    Album: Stillmatic
    Released: 2001
    CD(2): <uid>
    Vinyl(1): <uid for Stillmatic vinyl>
    $ ruby purchase.rb <uid for Stillmatic vinyl>
    Removed 1 vinyl of Stillmatic by Nas from the inventory
    $ ruby search_inventory.rb album stillmatic
    Artist: Nas
    Album: Stillmatic
    Released: 2001
    CD(2): <uid>
    $