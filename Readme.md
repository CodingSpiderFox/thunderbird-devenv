Helpful links at:


https://groups.google.com/forum/#!topic/mozilla.dev.builds/ni7ih5pSyW0

https://developer.mozilla.org/en-US/docs/Mozilla/Thunderbird/Thunderbird_extensions/Finding_the_code_for_a_feature
https://developer.mozilla.org/en-US/docs/Mozilla/Thunderbird/Thunderbird_extensions
https://developer.mozilla.org/en-US/docs/Mozilla/Thunderbird/Thunderbird_extensions/Useful_newsgroups_discussions
https://developer.mozilla.org/en-US/docs/Mozilla/Thunderbird/Thunderbird_extensions/Building_a_Thunderbird_extension

---------------------------------------------------------------------------------------------------------------------------------


Original instructions page (licensed under CC-BY-SA): https://developer.mozilla.org/en-US/docs/Mozilla/Developer_guide/Build_Instructions/Simple_Thunderbird_build


<p>This page covers the basic steps needed to build a bleeding-edge, development version of Thunderbird 60 or later. For Thunderbird up to 59, see the <a class="internal" href="Old_Thunderbird_build" rel="internal">old build documentation</a>. For additional, more detailed information, see the <a class="internal" href="../../../../Developer_Guide/Build_Instructions" rel="internal">build documentation</a>.</p>

<h2 id="Hardware_requirements">Hardware requirements</h2>

<ul>
	<li>At least 4 GB of RAM. 8 GB or more is recommended. While you can build Thunderbird on older hardware it can take quite a bit of time to compile on slower machines with less RAM.</li>
	<li>Good internet connection for the initial source download.</li>
</ul>

<h2 id="Build_prerequisites">Build prerequisites</h2>

<p>Depending on your Operating System you will need to carry out a different process to prepare your machine. So firstly complete the instructions for your OS and then continue following these build instructions.</p>

<ul>
	<li><a href="https://developer.mozilla.org/en-US/docs/Developer_Guide/Build_Instructions/Windows_Prerequisites" title="/en-US/docs/Developer_Guide/Build_Instructions/Windows_Prerequisites">Windows Build Prerequisites</a></li>
	<li><a href="https://developer.mozilla.org/en-US/docs/Simple_Firefox_build/Linux_and_MacOS_build_preparation" title="/en-US/docs/Simple_Firefox_build/Linux_and_MacOS_build_preparation">GNU/Linux Build Prerequisites</a></li>
	<li><a href="https://developer.mozilla.org/en-US/docs/Mozilla/Developer_guide/Build_Instructions/Mac_OS_X_Prerequisites">macOS Build Prerequisites</a></li>
</ul>

<h2 class="editable" id="MAPI_Headers">MAPI Headers</h2>

<p>On Windows: check that the MAPI header files from <a href="https://www.microsoft.com/en-us/download/details.aspx?id=12905">https://www.microsoft.com/en-us/download/details.aspx?id=12905</a> are installed because the MAPI header files (except MAPI.h) are not bundled with Visual Studio 2017 (Windows SDK 10). You should copy 17 of the 18 header files to a Windows SDK include directory so that the build process will find the files, that is <code>C:\Program Files (x86)\Windows Kits\10\Include\10.0.nnnnn.0\shared</code> respectively, where <code>nnnnn</code> is the highest number present on the system. Note that downloaded Outlook 2010 MAPI Header Files contain 18 fies, of which only 17 are needed. Do NOT copy MAPI.h, it is already in C:\Program Files (x86)\Windows Kits\10\Include\10.0.17134.0\um\MAPI.h.</p>

<p>As of April 2019, 10.0.17134.0 is needed to compile Thunderbird. Assuming standard installation loations, copy these 17 files to <code>C:\Program Files (x86)\Windows Kits\10\Include\10.0.17134.0\shared</code>.</p>

<pre>
<code>18/10/2010  16:11             7,334 MAPIAux.h
02/06/2009  17:02             7,938 MAPICode.h
02/06/2009  17:02            22,960 MAPIDbg.h
02/06/2009  17:02            84,644 MAPIDefS.h
02/06/2009  17:02            27,840 MAPIForm.h
02/06/2009  17:02            11,880 MAPIGuid.h
02/06/2009  17:02             2,648 MAPIHook.h
02/06/2009  17:02             5,359 MAPINls.h
02/06/2009  17:02             2,743 MAPIOID.h
02/06/2009  17:02            32,978 MAPISPI.h
02/06/2009  17:02            54,395 MAPITags.h
02/06/2009  17:02            26,467 MAPIUtil.h
02/06/2009  17:02            97,301 MAPIVal.h
02/06/2009  17:02             9,334 MAPIWin.h
02/06/2009  17:02             1,906 MAPIWz.h
02/06/2009  17:02            18,277 MAPIX.h
02/06/2009  17:02             5,012 MSPST.h</code></pre>

<h2 id="Get_the_source">Get the source</h2>

<div class="note"><strong>Note:</strong> On Windows, you won't be able to build the Thunderbird source code if it's under a directory with spaces in the path (e.g., don't use "Documents and Settings"). You can pick any other location, such as a new directory C:/thunderbird-src (where "C:/", with a forward slash, is intentional to clarify you are in the MozillaBuild command prompt per <a href="https://developer.mozilla.org/en-US/docs/Developer_Guide/Build_Instructions/Windows_Prerequisites">Windows build prerequisite</a>).</div>

<div class="note"><strong>Note:</strong> Parts of the build process also have problems when the source code is in a directory where the path is long (nested many levels deep). On Linux, this can manifest as problems setting up the virtualenv for running tests (failure to install pip or virtualenv because of OS access denied errors, where access is denied not because of permission problems, but because the paths being accessed have been truncated, and so do not exist). Having the source deep in a filesystem hierarchy can also cause problems with pymake builds on Windows. If you run into seemingly arbitrary problems in building and the source is deeply nested, try moving it closer to the root of your machine and re-building.</div>

<p>Get the latest Mozilla source code from Mozilla's <code>mozilla-central</code> Mercurial code repository, and check it out into a local directory <code>source/</code> (or however you want to call it). Then, get the latest Thunderbird source code from Mozilla's <code>comm-central</code> Mercurial code repository. It now needs to be placed <strong>inside</strong> the Mozilla source code, in a directory named <code>comm/</code> (this is inverse from Thunderbird 59 and earlier):</p>

<pre>
hg clone https://hg.mozilla.org/mozilla-central source/
cd source/
hg clone https://hg.mozilla.org/comm-central comm/
</pre>

<p class="editable">The source code requires 3.6GB of free space or more and additionally 5GB or more for default build. Instead of using <code>hg clone</code>, you can follow <a href="https://developer.mozilla.org/en-US/docs/Mozilla/Developer_guide/Source_Code/Mercurial/Bundles">these instructions</a> on downloading and "unpacking" a Mercurial bundle.</p>

<p class="editable"><strong>Warning: The page </strong><a href="/en-US/docs/Developer_Guide/Source_Code/Getting_comm-central" title="/en-US/docs/Developer_Guide/Source_Code/Getting_comm-central">Getting comm-central Source Code Using Mercurial [en-US]</a><strong> is 99% out of date!</strong> Only useful content is working with Github.</p>

<h2 class="editable" id="Build_configuration">Build configuration</h2>

<p>To build Thunderbird, you need to add a file named <code>mozconfig</code> to the root directory of the mozilla-central checkout that contains the following line:</p>

<pre>
ac_add_options --enable-application=comm/mail</pre>

<p>You can create a file with this line by doing this in the <code>source/</code> directory:</p>

<pre>
echo 'ac_add_options --enable-application=comm/mail' &gt; mozconfig
</pre>

<p>If you omit this line, the build system will build Firefox instead. Other build configuration options can be added to this file, although it's <strong>strongly</strong> recommended that you only use options that you fully understand. For example, to create a debug build instead of a release build, that file would also contain the line:</p>

<pre>
ac_add_options --enable-debug</pre>

<p>Each of these <code>ac_add_options</code> entries needs to be on its own line.</p>

<p>For more on configuration options, see the page <a href="/en/Configuring_Build_Options" rel="internal" title="en/Configuring Build Options">Configuring build options</a>. Note that if you use an MOZ_OBJDIR it cannot be a sibling folder to your source directory. Use an absolute path to be sure!</p>

<h4 id="To_also_build_Lightning_when_building_Thunderbird">To also build Lightning when building Thunderbird</h4>

<p>Add the following line to your <code>mozconfig</code> file:</p>

<pre>
ac_add_options --enable-calendar
</pre>

<p>To add that line you can do this in the <code>source/</code> directory:</p>

<pre>
echo 'ac_add_options --enable-calendar' &gt;&gt; mozconfig
</pre>

<h2 id="Building">Building</h2>

<p>Before you start, make sure that the version you checked out is not busted. For hg tip, you should see green Bs on <a href="https://treeherder.mozilla.org/#/jobs?repo=comm-central">https://treeherder.mozilla.org/#/jobs?repo=comm-central</a></p>

<p>To start the build, cd into the source directory, and run:</p>

<pre>
./mach build
</pre>

<p>mach is our command-line tool to streamline common developer tasks. See the <a href="/en-US/docs/Developer_Guide/mach" title="/en-US/docs/Developer_Guide/mach">mach</a> article for more.</p>

<p>Building can take a significant amount of time, depending on your system, OS, and chosen build options. Linux builds on a fast box may take under 15 minutes, but Windows builds on a slow box may take several hours. <strong><a href="/en/Developer_Guide/Mozilla_build_FAQ#Making_builds_faster" rel="internal" title="https://developer.mozilla.org/en/Mozilla_Build_FAQ#Making_builds_faster">Tips for making builds faster</a></strong>.</p>

<p><span style="line-height:1.572">The executable will be at the location listed under <strong>Running</strong> below.</span></p>

<h2 id="Running">Running</h2>

<p>To run your build, you can use</p>

<pre class="line-numbers  language-html">
<code class="language-html">./mach run</code></pre>

<p>There are various command line parameters you can add, e.g. to specify a profile.</p>

<p>Various temporary files, libraries, and the Thunderbird executable will be found in your <strong>object directory</strong> (under <code>comm-central/</code>), which is prefixed with <strong><code>obj-</code></strong>. The exact name depends on your system and OS. For example, a Mac user may get an object directory name of <strong><code>obj-x86_64-apple-darwin10.7.3/</code></strong>.</p>

<p>The Thunderbird executable in particular, and its dependencies are located under the <code>dist/bin</code> folder under the object directory. To run the executable from your <code>comm-central</code> working directory:</p>

<ul>
	<li><strong>Windows:</strong> <code>obj-.../dist/bin/thunderbird.exe</code></li>
	<li><strong>Linux:</strong> <code>obj-.../dist/bin/thunderbird</code></li>
	<li><strong>macOS:</strong> <code>obj-.../dist/Daily.app/Contents/MacOS/thunderbird</code></li>
</ul>

<h2 id="How_to_update_and_build_again">How to update and build again</h2>

<p>In your source directory:</p>

<pre>
hg pull -u
cd comm
hg pull -u
cd ..
</pre>

<p>or same commands shorter:</p>

<pre>
hg pull -u; (cd comm; hg pull -u)
</pre>

<p>Then just re-run the <em>mach</em> command above. This will only recompile files that changed, but it's still a long haul.</p>

<h2 id="Rebuilding">Rebuilding</h2>

<p>To build after making changes, run</p>

<pre>
./mach build
</pre>

<p>again. This will only rebuild what is necessary for these changes. It is also possible to rebuild specifically.</p>

<p>If you changed C or C++ files, run:</p>

<pre>
./mach build binaries
</pre>

<p>If you changed JavaScript or XUL files, on macOS or Linux you don't have to rebuild since the files in the object directory are linked to the ones in the source directory. On Windows run:</p>

<pre>
./mach build path/to/dir
</pre>

<p>This is the tricky bit since you need to specify the directory that installs the files, which may be a parent directory of the changed file's directory. For example, to just rebuild the Lightning calendar extension:</p>

<pre>
./mach build comm/calendar/lightning
</pre>

<p>For all other changes run the full rebuild:</p>

<pre>
./mach build
</pre>

<h2 id="Problems_Building">Problems Building?</h2>

<p>Have you:</p>

<ul>
	<li>Check <a class="external" href="https://treeherder.mozilla.org/#/jobs?repo=comm-central" title="https://treeherder.mozilla.org/#/jobs?repo=comm-central">comm-central on Treeherder</a> for known failures at the time you pulled the code. The current status of the trunk can also be checked at <a href="https://treestatus.mozilla.org/">https://treestatus.mozilla.org/</a>

	<ul>
		<li>If the trunk is broken (i.e. closed), you may wish to consider building <a href="/En/Developer_Guide/Source_Code/Getting_comm-central" title="https://developer.mozilla.org/En/Developer_Guide/Source_Code/Getting_comm-central">one of the branches</a> (to pull the source code from a branch, just replace the url to the repository in the hg clone instruction).</li>
	</ul>
	</li>
	<li>Check to make sure that the path in which you placed the source code has no spaces, and is not too long.</li>
	<li>Searched the <a class="link-https" href="https://bugzilla.mozilla.org/" title="https://bugzilla.mozilla.org/">bug database</a> for issues relating to your problem (e.g., platform-specific issues).</li>
	<li>Try asking in <a class="external" href="https://groups.google.com/group/mozilla.dev.builds/" title="http://groups.google.com/group/mozilla.dev.builds/">mozilla.dev.builds</a> - include details of what is in your mozconfig, and what the actual error is.</li>
	<li>Check if your mozilla/ is a symlink. A symlink there is not supported.</li>
	<li>Check for <code>@TOPSRCDIR@</code> or relative paths in your mozconfig. Those have caused several problems historically and tend to be poorly tested when the build system changes.</li>
	<li>If on Windows you get link errors like "LNK1102: out of memory" or "LNK1318: Unexpected PDB error; OK (0)", try deleting the largest .PDB files before rushing out the door to buy more RAM. Clobbering (see below) will also remove those files.</li>
	<li>Try with a clean obj-dir. You can clean out previous build artefacts using
	<pre class="language-html">
<code class="language-html">./mach clobber</code></pre>
	</li>
</ul>

<h3 id="References">References</h3>

<ul>
	<li><a class="internal" href="/En/Developer_Guide/Build_Instructions" title="En/Developer Guide/Build Instructions">General Build Documentation</a></li>
	<li><a class="internal" href="/en/comm-central" title="en/comm-central">comm-central</a></li>
	<li><a href="/en/Using_the_Mozilla_symbol_server" title="en/Using the Mozilla symbol server">Using the Mozilla symbol server</a></li>
</ul>
