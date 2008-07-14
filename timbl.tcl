#! /home/ilk/systems/blt2.3/bltwish 
#
# TiMBL parameter selection and invocation
#

global argc
global argv

set gWekaHome $env(WEKAHOME)
source $gWekaHome/bin/weka-common.tcl
set preffile [format "%s/.weka%sTIMBLrc" $env(HOME) $gWekaVersion]

# =====================================================================
# getArgs {}
# get the parameters from the user
#


proc setDefaults {} {
    .argf.paramf.algorithmf.mbl invoke
    .argf.paramf.metricf.wo invoke
    .argf.paramf.weightf.gr invoke
    .argf.paramf.kparamf.one invoke
}

proc getArgs {} {
    # global gFormat
    global gAlgorithm
    global gMetric
    global gWeight
    global gKparam
    global gConfirm
    global env
    global Lastval
    global gTest gWekaVersion

    # set up Window Manager stuff
    wm minsize . 0 0
    wm title . [format "WEKA %s - TiMBL Parameters" $gWekaVersion]
    wm geometry . +100+200

    # set up frames

    frame .argf -border 2 -relief sunken
    frame .butf -border 2 -relief sunken
    pack .argf .butf -side top -fill both -expand yes

    # set up argument frames, labels and buttons
    # set up labels
    frame .argf.labelf -border 1

    # set buttons and entries
    frame .argf.paramf -border 1

    # Algoritm (MBL or IGTRee)

    label .argf.labelf.algorithml -text "Algorithm:" \
	    -border 2 \
	    -anchor w -width 40
    frame .argf.paramf.algorithmf
    radiobutton .argf.paramf.algorithmf.mbl -anchor w -border 2 -text "MBL" \
	    -variable gAlgorithm -relief flat -width 8 -value 0
    radiobutton .argf.paramf.algorithmf.igtree -anchor w -border 2 -text "IGTree" \
	    -variable gAlgorithm -relief flat -width 8 -value 1

    # Metric

    label .argf.labelf.metricl -text "Metric:" \
	    -border 2 \
	    -anchor w -width 40
    frame .argf.paramf.metricf
    radiobutton .argf.paramf.metricf.wo -anchor w -border 2 -text "Weighted Overlap" \
	    -variable gMetric -relief flat -width 8 -value 0
    radiobutton .argf.paramf.metricf.mvdm -anchor w -border 2 -text "MVDM" \
	    -variable gMetric -relief flat -width 8 -value 1
    radiobutton .argf.paramf.metricf.mvdmps -anchor w -border 2 -text "MVDM (prec-computed)" \
	    -variable gMetric -relief flat -width 8 -value 2

    # Feature Weighting

    label .argf.labelf.weightl -text "Feature Weighting:" \
	    -border 2 \
	    -anchor w -width 40
    frame .argf.paramf.weightf
    radiobutton .argf.paramf.weightf.no -anchor w -border 2 -text "No Weighting" \
	    -variable gWeight -relief flat -width 8 -value 0
    radiobutton .argf.paramf.weightf.gr -anchor w -border 2 -text "Gain Ratio" \
	    -variable gWeight -relief flat -width 8 -value 1
    radiobutton .argf.paramf.weightf.ig -anchor w -border 2 -text "Information Gain" \
	    -variable gWeight -relief flat -width 8 -value 2

    # K Parameter

    label .argf.labelf.kparaml \
	    -text "k (number of nearest neighbors):" \
	    -border 2 \
	    -anchor w -width 40
    frame .argf.paramf.kparamf
    radiobutton .argf.paramf.kparamf.one \
	    -anchor w -border 2 -text "Default (k=1)" \
	    -command { \
	    .argf.paramf.kparamf.kparam configure -state disabled; \
	    set gKparam "" } \
	    -variable gKparam -value 1 -relief flat -width 8

    radiobutton .argf.paramf.kparamf.other \
	    -anchor w -border 2 -text "Specified" \
	    -command { \
	    .argf.paramf.kparamf.kparam configure -state normal}
    entry .argf.paramf.kparamf.kparam -border 2 -relief sunken \
	    -textvariable gKparam -width 6

    # pack everything

    pack .argf.labelf .argf.paramf -side left -fill y

    pack .argf.labelf.algorithml -side top -fill x -expand 1
    pack .argf.labelf.metricl -side top -fill x -expand 1
    pack .argf.labelf.weightl -side top -fill x -expand 1
    pack .argf.labelf.kparaml -side top -fill x -expand 1

    pack .argf.paramf.algorithmf -side top -fill x
    pack .argf.paramf.algorithmf.mbl .argf.paramf.algorithmf.igtree -side left -fill x 

    pack .argf.paramf.metricf -side top -fill x
    pack .argf.paramf.metricf.wo .argf.paramf.metricf.mvdm .argf.paramf.metricf.mvdmps -side left -fill x 

    pack .argf.paramf.weightf -side top -fill x
    pack .argf.paramf.weightf.no .argf.paramf.weightf.gr .argf.paramf.weightf.ig -side left -fill x 

    pack .argf.paramf.kparamf -side top -fill x
    pack .argf.paramf.kparamf.one .argf.paramf.kparamf.other \
	    .argf.paramf.kparamf.kparam -side left -fill x 

    setDefaults

    button .butf.cancel -text "Cancel" \
	    -command "set gConfirm 0; destroy ."
    button .butf.defaults -text "Defaults" \
	    -command setDefaults
    button .butf.okay -text "Okay" \
	    -command "set gConfirm 1; destroy ."

    pack .butf.cancel .butf.defaults .butf.okay -side left -expand yes \
	    -padx 2 -pady 2 -fill x

    tkwait visibility .
    grab .
    tkwait window .
}

# ============================================================================
# setOptions
# write the options out to a file
#

proc setOptions {} {
    global env
    global preffile
}

# ============================================================================
# tmpName
# make a temporary filename based on hostname, time and process id
#

proc tmpName { name ppid } {
    global gWekaHome

    return [format "/tmp/weka.TIMBL.%s.%s.%05d.%05d" \
	    [string range [file root [file tail $name]] 0 15] \
	    [exec $gWekaHome/bin/wekadate -t] $ppid [pid]]

}

# ==========================================================================
# printSchemeHeader
# print out a header with the parameters

proc printSchemeHeader { tempArff } {
    global gFilename
    global gInstances
    global gClassname
    global gAttributes
    global gWekaHome
    global gTest

    puts [format "TiMBL - %s" \
	    [exec $gWekaHome/bin/wekadate -f]]
    puts "==========================================================================================\n"
    puts [format "Filename:\t\t%s" $gFilename]
    puts [format "Relation:\t\t%s" \
	    [eval exec $gWekaHome/bin/arffinfo -r < $gFilename]]
    puts [format "Instances:\t\t%d" $gInstances]
    puts [format "Class Attribute:\t%s" $gClassname]
    puts [format "Attributes Used:\t%s" $gAttributes]
    set attCount 0
    set fp [open "|$gWekaHome/bin/arffinfo -a < $tempArff" r]
    while { [gets $fp line] >= 0 } {
	incr attCount 1
	puts [format "\t\t\t%s" $line]
    }
    close $fp
    puts [format "No. of Attributes:\t%d" $attCount]
    if { $gTest != "" } {
	puts [format "Test File:\t\t%s" $gTest]
	puts [format "Test Instances:\t\t%d" \
		[eval exec $gWekaHome/bin/arffinfo -i < $gTest]]
    } else {
	puts "Test File:\t\tUsing training set"
    }
    puts "==========================================================================================\n"

}

# ==========================================================================
# main program
#

# set up default colours and fonts

#option add *background lightsteelblue2
#option add *activeBackground lightsteelblue1
#option add *foreground black
#option add *activeForeground black
#option add *disabledForeground lightsteelblue3

#option add *Scrollbar.foreground lightsteelblue2
#option add *Scrollbar.activeForeground lightsteelblue2

#option add *Font -Adobe-Helvetica-Bold-R-Normal--*-140-*

if { $argc < 6 } {
    puts "usage: timbl.tcl arff-file ppid attribute-list classID className instances \[testfile\]"
    exit;
}

# global gFormat

global gAlgorithm
global gMetric
global gWeight
global gKparam


global gConfirm
global env

set gFilename [lindex $argv 0]
set ppid [lindex $argv 1]
set gAttributes [lindex $argv 2]
set gClass [lindex $argv 3]
set gClassname [lindex $argv 4]
set gInstances [lindex $argv 5]
if { $argc == 7 } {
    set gTest [lindex $argv 6]
} else {
    set gTest ""
}

set gBlendpct "20"
set filestem [tmpName [file tail $gFilename] $ppid]
set colsfile [format "%s.data" $filestem]
set testfile [format "%s.test" $filestem]

getArgs
if { $gConfirm == 0 } {
    puts "Cancel"
    flush stdout
    exit 0
} else {
    puts "Okay"
    flush stdout
}

set commandline ""
if {$gAlgorithm != ""} {
    catch {append commandline [format " -a %s " $gAlgorithm]}
}

if {$gMetric != ""} {
    catch {append commandline [format " -m %s " $gMetric]}
}

if {$gWeight != ""} {
    catch {append commandline [format " -w %s " $gWeight]}
}

if {$gKparam != ""} {
    catch {append commandline [format " -k %s " $gKparam]}
}

exec $gWekaHome/bin/arffcols -i $gAttributes < $gFilename | $gWekaHome/bin/arfftoibl > $colsfile

if { $gTest != "" } {    
    exec $gWekaHome/bin/arffcols -i $gAttributes < $gTest | $gWekaHome/bin/arfftoibl > $testfile
} else {
    set testfile $colsfile
}

append commandline " -O /tmp "

catch {append commandline [format " -f %s " $colsfile]}
catch {append commandline [format " -t %s " $testfile]}

# ****** Print out the Scheme Header
printSchemeHeader $colsfile


if { ! [file exists $gWekaHome/bin/Timbl] } {
    puts stderr "$gWekaHome/bin/Timbl is not installed. "
    exit 1
}

catch {eval exec $gWekaHome/bin/Timbl $commandline } errmsg
# now i have to get the filename of the output file and copy it to > $filestem.output

if {$errmsg != ""} {
    puts stderr $errmsg
} else {
    puts [eval exec cat $filestem.output]
    flush stdout
}

eval exec rm -f [glob $filestem*]



