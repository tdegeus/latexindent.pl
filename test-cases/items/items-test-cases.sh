#!/bin/bash
# set verbose mode, 
# see http://stackoverflow.com/questions/2853803/in-a-shell-script-echo-shell-commands-as-they-are-executed
loopmax=7
[[ $# -eq 1 ]] &&  loopmax=$1  # mand-args-test-cases.sh <maxloop>
echo "mand-args-test-cases.sh will run with loopmax = $loopmax"

set -x 

# making strings of tabs and spaces gives different results; 
# this first came to light when studying items1.tex -- the following test cases helped to 
# resolve the issue
latexindent.pl -s -t spaces-and-tabs.tex -l=tabs-follow-tabs.yaml -o=spaces-and-tabs-tft.tex
latexindent.pl -s -t spaces-and-tabs.tex -l=spaces-follow-tabs.yaml -o=spaces-and-tabs-sft.tex
latexindent.pl -s -t spaces-and-tabs.tex -l=tabs-follow-spaces -o=spaces-and-tabs-tfs.tex
# first lot of items
latexindent.pl -s -w items1.tex
# nested itemize/enumerate environments -- these ones needed ancestors, the understanding/development of which took about a week!
latexindent.pl -s -w items1.5.tex
latexindent.pl -s -w items2.tex
latexindent.pl -s -w items3.tex
latexindent.pl -s -w items4.tex
latexindent.pl -s -w items5.tex
# noAdditionalIndent
latexindent.pl -s -l=noAdditionalIndentItemize.yaml items1.tex -o=items1-noAdditionalIndentItemize.tex
latexindent.pl -s -l=noAdditionalIndentItems.yaml items1.tex -o=items1-noAdditionalIndentItems.tex
latexindent.pl -s -g=other.log -l=noAdditionalIndent-myenv.yaml items3.tex -o=items3-noAdditionalIndent-myenv.tex
# indentRules
latexindent.pl -s -l=indentRulesItemize.yaml items1.tex -o=items1-indentRulesItemize.tex
latexindent.pl -s -l=indentRulesItems.yaml items1.tex -o=items1-indentRulesItems.tex
# test different item names
latexindent.pl -s -l=myitem.yaml -w items1-myitem.tex
latexindent.pl -s -l=part.yaml -w items1-part.tex
# modify linebreaks starts here
latexindent.pl -s -m items1.tex -o=items1-mod0.tex
latexindent.pl -tt -s -m items1-blanklines.tex -o=items1-blanklines-mod0.tex 
latexindent.pl -s -m items2.tex -o=items2-mod0.tex
set +x
for (( i=1 ; i <= $loopmax ; i++ )) 
do 
    set -x
    latexindent.pl -s -tt -m -l=items-mod$i.yaml items1.tex -o=items1-mod$i.tex
    latexindent.pl -s -tt -m -l=items-mod$i.yaml items2.tex -o=items2-mod$i.tex
    latexindent.pl -s -tt -m -l=items-mod$i.yaml items3.tex -o=items3-mod$i.tex
    # blank line tests
    latexindent.pl -s -tt -m -l=items-mod$i.yaml items1-blanklines.tex -o=items1-blanklines-mod$i.tex
    latexindent.pl -s -tt -m -l=items-mod$i.yaml,unPreserveBlankLines.yaml items1-blanklines.tex -o=items1-blanklines-unPreserveBlankLines-mod$i.tex
    latexindent.pl -s -tt -m -l=items-mod$i.yaml,BodyStartsOnOwnLine.yaml items1.tex -o=items1-BodyStartsOnOwnLine-mod$i.tex
    # starts on one line, adds linebreaks accordingly
    latexindent.pl -s -tt -m -l=items-mod$i.yaml items5.tex -o=items5-mod$i.tex
    latexindent.pl -s -tt -m -l=items-mod$i.yaml items6.tex -o=items6-mod$i.tex
    latexindent.pl -s -tt -m -l=items-mod$i.yaml items7.tex -o=items7-mod$i.tex -g=other.log
    set +x
done
# ifelsefi within an item
latexindent.pl -s items8.tex -o=items8-mod0.tex
git status
