mkdir results
cp merge-results.xml results
cd results

_CATEGORIES=("ReachSafety-Arrays" "ReachSafety-BitVectors" "ReachSafety-ControlFlow" "ReachSafety-Floats" "ReachSafety-Heap" "ReachSafety-Loops" "ReachSafety-ProductLines" "ReachSafety-Recursive" "ConcurrencySafety-Main" "MemSafety-Arrays" "MemSafety-Heap" "MemSafety-LinkedLists" "MemSafety-Other" "MemSafety-MemCleanup" "SoftwareSystems-BusyBox-MemSafety" "SoftwareSystems-OpenBSD-MemSafety" "NoOverflows-BitVectors" "NoOverflows-Other" "Termination-MainHeap" "Termination-MainControlFlow" "Termination-Other" "ReachSafety-ECA" "ReachSafety-Sequentialized" "SoftwareSystems-AWS-C-Common-ReachSafety" "SoftwareSystems-DeviceDriversLinux64-ReachSafety" "SoftwareSystems-BusyBox-NoOverflows" "MemSafety-TerminCrafted")

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
