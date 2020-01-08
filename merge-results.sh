mkdir results
cp merge-results.xml results
cd results

_CATEGORIES=("MemSafety-Other" "MemSafety-MemCleanup")

function prepare_files {
    CATEGORY="$1"
    echo "Preparing category $CATEGORY"

    unzip ../benchexec-$CATEGORY.zip -d $CATEGORY    
    bzip2 -dk $CATEGORY/output-tool.logtool-*.bz2
}

for i in ${_CATEGORIES[@]};
do
    prepare_files $i
done

table-generator -x merge-results.xml
echo "DONE."
