CheapRandom
============

Description
-----------
CheapRandom is a set of tools for pseudo random number generation from arbitrary data. CheapRandom gives complete control over the number generation - useful for easily repeatable software testing. CheapRandom is information conserving and generally appears to produce lower chi-squared statistics than Kernel::rand.

Version
-------
v0.8.0 beta, developed using ruby 1.9.3 and rspec 2.10.0.

Installation
------------
Clone the repository. Create a directory called random, parallel to the repository. Use examples/make\_seed.rb to make a seed file - (a 256 byte permutation file) from arbitrary data using the default seed.

Usage and documentation
-----------------------
Study the programs in the examples and spec directories and use the .rb files in the lib directory. See below for more information.

License
-------
Released under the MIT License.  See the [LICENSE][license] file for further details.

[license]: https://github.com/bardibardi/cheap_random/blob/master/LICENSE.md

Create a large file of random bytes
-----------------------------------
Copy (or link) some large file (with a known hash) to the random directory. Use examples/cr.rb to randomize it into a .random file (the rspec tests expect test.zip.random).

Use a large file of random bytes as a source of random numbers
--------------------------------------------------------------
Use examples/cb.rb to see how to use lib/cheap\_bits.rb to create a random number generator which uses that large file. spec/using\_cheap\_bits\_cheap\_random\_spec.rb uses lib/cheap\_bits.rb to generate random numbers. It should be compared with spec/cheap\_random\_spec.rb which uses Kernel::rand.

Manage a large file used as the source of random numbers
--------------------------------------------------------
The large file does not need to be kept if it is something like jruby-bin-1.6.7.2.zip. For example, one can keep a reference to its internet location, its sha1 hash and the seed file used when creating its .random file.

Manage the seed file used when processing arbitrary data into random bits
-------------------------------------------------------------------------
The seed file does not need to be kept if it is generated from the default seed and some arbitrary file, say a picture of a pet cat. One can simply keep the picture of the pet cat.

CheapBits#random(n) in lib/cheap\_bits.rb
-----------------------------------------
random(n), where n is an integer greater than zero, behaves like Kernel::rand(n) It is only dependent on the .random file, not on how the .random file was generated. Note that the .random file is treated like a ring buffer of random bits.

CheapRandom::cheap\_random3!(is\_randomizing, perm, s)
------------------------------------------------------
cheap\_random3! updates s, a byte string. perm is a seed, a byte string of 256 bytes all different. is\_randomizing is a boolean which determines whether or s is being randomized or un-randomized. cheap\_random3! returns another perm / seed. spec/cheap\_random\_spec.rb is used to test cheap\_random3!

