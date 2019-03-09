#!/bin/bash
payload=`echo "${1}"|head -n1|tr -d ':'`; #generate the active payload
previous_block=`tail -n1 'database'`; #grab the last known block from the 'database' record
id=$((${previous_block%%:*}+1)); # increment
while : ; do
	nonce=$RANDOM; # generate a quasi-random seed to test against
	checksum=`echo "${previous_block##*:}:$id:$payload:$nonce"|sha256sum|sed 's/[ -]*$//'`;
	ndr=$(($nonce - $RANDOM)); # generate a quasi-number ( based on the original nonce seed )
	ndr="${ndr: -2}"; # grab the last 2 characters from the seed.
	#[[ "${checksum: -2}" == '00' ]] && break;
	[[ "${checksum: -2}" == "${ndr}" ]] && break; # test the cs-hash against the ndr
done;
echo "$id:$payload:$nonce:$checksum">>'database'; #feedback the results to terminal
