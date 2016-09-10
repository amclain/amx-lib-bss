# AMX BSS API

amx-lib-bss

This library contains the code to interface with BSS Soundweb London devices,
like the BLU series products.

It is assumed the developer has read the Soundweb London Interface Kit
documentation ([London DI Kit.pdf](http://www.jands.com.au/__data/assets/pdf_file/0009/38475/London_DI_Kit_v2.pdf))
provided by BSS. The conventions used in this library try to follow the
terminology used by BSS. A copy of the PDF is installed in the London Architect
application directory, which by default is:

```text
    C:\Program Files\Harman Pro\London Architect\London DI Kit.pdf
```


## Download

**Git Users:**

https://github.com/amclain/amx-lib-bss


**Mercurial Users:**

https://bitbucket.org/amclain/amx-lib-bss


**Zip File:**

Both sites above offer a feature to download the source code as a zip file.
Any stable release, as well as the current development snapshot can be downloaded.


## Issues, Bugs, Feature Requests

Any bugs and feature requests should be reported on the GitHub issue tracker:

https://github.com/amclain/amx-lib-bss/issues


**Pull requests are preferred via GitHub.**

Mercurial users can use [Hg-Git](http://hg-git.github.io/) to interact with
GitHub repositories.


## Usage

### Include

Simply include the file `amx-lib-bss.axi` in your project.

### Conventions

All elements exposed globally by this library are prefixed with `BSS`.
    
Underscores prefixing function names indicate low-level functions used by this
library. These functions typically won't need to be used by the control system
developer.

BSS controls are referenced by an 8-byte array consisting of the object's 6-byte
HiQnet Address (node, virtual device, object) followed by the parameter's 2-byte
state variable ID. This looks like:

```text
MY_FADERS[] = {$05, $F1, $03, $00, $01, $07, $4E, $20}
               ------ HiQnet Address ------  -- SV --
```

It is also possible for a program to only store the HiQnet addresses and append
the state variable when calling this API. For example, calling a `setVolume()`
function will always adjust a gain, so the function can append the gain fader
state variable to the HiQnet address passed to it.

A network connection only needs to be established from AMX to one BSS device,
since HiQnet can pass messages between nodes. Bind `vdvBSS` to one physical
device.

### Examples

See the [examples](examples) directory for source code examples.
