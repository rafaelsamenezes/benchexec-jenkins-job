mkdir results
cp merge-results.xml results
cd results

_CATEGORIES=("ReachSafety-Arrays" "ReachSafety-BitVectors" "ReachSafety-ControlFlow" "ReachSafety-Floats" "ReachSafety-Heap" "ReachSafety-Loops" "ReachSafety-Recursive" "SoftwareSystems-BusyBox-MemSafety" "Termination-MainHeap" "ReachSafety-Sequentialized" "SoftwareSystems-DeviceDriversLinux64-ReachSafety" "SoftwareSystems-SQLite-MemSafety")

function prepare_files {
    CATEGORY="$1"
    echo "Preparing category $CATEGORY"

    unzip ../benchexec-$CATEGORY.zip -d $CATEGORY    
    bzip2 -dk $CATEGORY/*.bz2
}

for i in ${_CATEGORIES[@]};
do
    prepare_files $i
done

table-generator -x merge-results.xml
echo "DONE."
