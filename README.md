CheapRandom
============

Description
-----------
**CheapRandom** is a set of tools for pseudo random number generation from arbitrary data. The properties of the **CheapRandom seed** make convenient random number generation possible -- useful for easily repeatable software testing. The **CheapRandom algorithm** is information conserving and generally appears to produce lower chi-squared statistics than **Kernel::rand** i.e. it appears to be more random. The **CheapRandom algorithm**, an original work by Bardi Einarsson, has been in use for 6 years.

Why should one use CheapRandom?
-------------------------------
Simple and powerful: The **CheapRandom algorithm** is fast, fast enough to be practical to use in ruby as ruby.  The properties of the **CheapRandom seed** (see below) make management of seeds and random data easy and verifiable. 

Version
-------
v0.9.3 with comprehensive tests, developed using ruby 1.9.3 and rspec 2.10.0 is the same as v0.9.1 (gem v0.9.2) aside from the addition of the **examples2** directory.

Installation
------------
Get the v0.9.3 gem or clone the repository. Create a directory called **random** in the repository root. Use **examples/make\_seed.rb** to make a **the.seed** file - (a 256 byte permutation file) from arbitrary data using the **CheapRandom default seed**.

Usage and documentation
-----------------------
Study the programs in the **examples** and **spec** directories and use the **.rb** files in the **lib** directory. See below for more information. Additionally, the **examples2** directory contains tools for the **crx** bash script, using the c programs **cr** and **rpb**, for a very convenient way of working with cheap random files.

License
-------
Copyright (c) 2006 - 2012 Bardi Einarsson. Released under the MIT License.  See the [LICENSE][license] file for further details.

[license]: https://github.com/bardibardi/cheap_random/blob/master/LICENSE.md

Create a large file of random bytes
-----------------------------------
Copy (or link) some large file (with a known hash) to the **random** directory. Use **examples/cr.rb** to randomize it into a **.random** file (the rspec tests expect **test.zip** and **test.zip.random**).

Use a large file of random bytes as a source of random numbers
--------------------------------------------------------------
Use **examples/cb.rb** to see how to use **lib/cheap\_bits.rb** to create a random number generator which uses that large file. **spec/using\_cheap\_bits\_cheap\_random\_spec.rb** uses **lib/cheap\_bits.rb** to generate random numbers. It should be compared with **spec/cheap\_random\_spec.rb** which uses **Kernel::rand**.

Manage a large file used as the source of random numbers
--------------------------------------------------------
The large file does not need to be kept if it is something like **jruby-bin-1.6.7.2.zip**. For example, one can keep a reference to its internet location, its sha1 hash and the **CheapRandom seed** file used when creating its **.random** file.

Manage the seed file used when generating .random files
-------------------------------------------------------
The **CheapRandom seed** file does not need to be kept if it is generated from the **CheapRandom default seed** and some arbitrary file, say a picture of a pet cat. One can simply keep the picture of the pet cat.

CheapBits#random(n) in lib/cheap\_bits.rb
-----------------------------------------
**random(n)**, where n is an integer greater than zero, behaves like **Kernel::rand(n)**. It is only dependent on the **.random** file, not on how the **.random** file was generated. Note that the **.random** file is treated like a ring buffer of random bits.

CheapRandom::cheap\_random3!(is\_randomizing, perm, s)
------------------------------------------------------
**cheap\_random3!** updates **s**, a byte string. **perm** is a **CheapRandom seed**, a byte string of 256 bytes all different. **is\_randomizing** is a boolean which determines whether or **s** is being randomized or un-randomized. **cheap\_random3!** returns another perm / **CheapRandom seed**. **spec/cheap\_random\_spec.rb** is used to test **cheap\_random3!**. **spec/using\_cheap\_bits\_cheap\_random\_spec.rb** is also used to test **cheap\_random3!** and to demonstrate the use of **lib/cheap\_bits.rb**.

Properties of the CheapRandom seed
----------------------------------
**CheapRandom seeds** are easy to identify. All the **CheapRandom seeds** are 256 bytes, all different.

**CheapRandom seeds** can be used to identify files. **CheapRandom seeds** are a type of hash function result. When **test.zip** is processed into **test.zip.random**, **test.zip.seed** is also produced. **test.zip.seed** is the result of **cheap\_random3!** on **test.zip**.

Given the same start seed -- **the.seed**, the result seed files **test.zip.seed** and **test.zip.random.seed** are always identical. (**test.zip.random.seed** is the result of **cheap\_random3!** on **test.zip.random**.)

make\_seed.rb
-------------
**ruby examples/make\_seed.rb pet\_cat.png** => **random/pet\_cat.png.seed** which should be copied to **random/the.seed**

cr.rb
-----
**ruby examples/cr.rb test.zip** => **random/test.zip.random** and **random/test.zip.seed**

cb.rb
-----
**ruby examples/cb.rb** => listing of byte frequencies for **random/test.zip.random**

chi\_squared.rb
---------------
**ruby examples/chi\_squared.rb test.zip** => a listing of a chi-squared statistic for **random/test.zip.random** followed by a listing of a chi-squared statistic for the same amount of data generated by **Kernel::rand 256**

Test
----
Make sure that the **random** directory exists and contains the files **pet\_cat.png**, **pet\_cat.png.seed**, **the.seed**, **test.zip** and **test.zip.random** as described above. Run **rspec**. The tests are quite comprehensive.

Other possible uses of CheapRandom
----------------------------------
There are a number of intriguing possible uses for the **CheapRandom algorithm** and the **CheapRandom seed** properties beyond random number generation.

Additional Examples - C code and In Place File Processing
---------------------------------------------------------
The **examples2** directory contains examples related to **example2/cr.c** These examples are designed to be on the PATH and require the use of a C compiler.

cr.c Cheap Random Filter and Friends
------------------------------------
**gcc -Wall cr.c -o cr** creates the **cr** cheap random filter. Running **cr h** writes out some help text. **cr <somefile >some_file.random** and **cr u <somefile.random >somefile** are the most basic use of **cr**. **the.seed** is hard coded into **cr**. To see how, use **chex\_pipe.rb <the.seed** and compare the console output to the definition of SEED in **cr.c**. **the.seed** was generated by running the bash script **make_seed pet\_cat.png**


crf.rb Cheap Random File, In Place File Processing 
--------------------------------------------------
**crf.rb somefile** => **somefile.random** - somefile over-written in place, **somefile.the.seed**, **somefile.new.seed**. **crf.rb somefile.random** => **somefile** - somefile.random over-written in place, **somefile.random.the.seed**, **somefile.random.new.seed**. The seed used by **crf.rb** is a file designated by the environmental variable CR\_SEED if defined, otherwise **crf.rb** any one file located in **~/.cheap\_random**. If the designated file is a **.seed** file it will be used directly, otherwise a seed will be generated internally from the designated file. **~/.cheap\_random/pet_cat.png** can serve as a seed file for **crf.rb**.

crx and crxs Cheap Random File, In Place File Processing 
--------------------------------------------------------
**gcc -Wall rpb.c -o rpb**, **rpb** makes in place file processing possible for the bash scripts **crx** and **crxs**. **crx somefile** => **somefile.random** - somefile over-written in place. **crx somefile.random** => **somefile** - somefile.random over-written in place. **crxs** behaves like **crx** with the addition of the creation of the seed files **the.seed** and **new.seed**.
