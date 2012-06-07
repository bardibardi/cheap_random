CheapRandom
============

Description
-----------
CheapRandom is a set of tools for pseudo random number generation from arbitrary data. CheapRandom gives complete control over the number generation - useful for easily repeatable software testing.

Version
-------
v0.8.0 beta, developed using ruby 1.9.3 and rspec 2.10.0.

Installation
------------
Clone the repository and use the .rb files in the lib directory. Create a directory called random parallel to the repository. Use examples/make\_seed.rb to make a seed file - (a 256 byte permutation file)

Usage and documentation
-----------------------
Study the programs in the examples and spec directories. See below for more information.

License
-------
Released under the MIT License.  See the [LICENSE][license] file for further details.

[license]: https://github.com/bardibardi/cheap_random/blob/master/LICENSE.md

Create a large file of random bytes
-----------------------------------
Copy (or link) some large file (with a known hash) to the random directory. Use examples/cr.rb to randomize it into a .random file (the rspec tests expect test.zip.random).

Use a large file of random bytes as a source of random numbers
--------------------------------------------------------------
Use examples/cb.rb to see how to use lib/cheap\_bits.rb to create a random number generator which uses that large file. spec/using\_cheap\_bits\_cheap\_random\_spec.rb uses lib/cheap\_bits.rb to generate random numbers.

Manage a large file used as the sourco of random numbers
--------------------------------------------------------
The large file does not need to be kept if it is something like jruby-bin-1.6.7.2.zip. One can keep a reference to its internet location, a sha1 hash and the seed file used when creating the .random file.
 
