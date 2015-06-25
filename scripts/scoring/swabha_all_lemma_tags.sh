#!/bin/bash

set -e # fail fast

# Convert conll dependency parser output into our "all.lemma.tags" format
# dependency parsed files should be located at
# ${training_dir}/cv.{dev,test,train}.sentences.maltparsed.conll
# This will clobber the previous *.all.lemma.tags files, so make sure they're
# backed up if you need them.

source "$(dirname ${0})/../../training/config.sh"

prefixes="train dev test"
for prefix in $prefixes ; do
    tmp_parse_file="${training_dir}/cv.${prefix}.sentences.tmp_parse_file"
    ${JAVA_HOME_BIN}/java -classpath ${classpath} -Xms1g -Xmx1g \
        edu.cmu.cs.lti.ark.fn.data.prep.AllAnnotationsMergingWithoutNE \
          "${training_dir}/cv.${prefix}.sentences.tokenized" \
          "${training_dir}/cv.${prefix}.sentences.turboparsed.${turbomdl}.stanford.lemmatized.conll" \
          "${tmp_parse_file}" \
          "${training_dir}/cv.${prefix}.sentences.turboparsed.${turbomdl}.stanford.all.lemma.tags"
    rm "${tmp_parse_file}"
done


#tmp_parse_file="${training_dir}/cv.${prefix}.sentences.tmp_parse_file"
#${JAVA_HOME_BIN}/java -classpath ${classpath} -Xms1g -Xmx1g \
#    edu.cmu.cs.lti.ark.fn.data.prep.AllAnnotationsMergingWithoutNE \
#    "${training_dir}/cv.dev.sentences.tokenized" \
#    "${training_dir}/cv.dev.sentences.turboparsed.standard.stanford.lemmatized.conll" \
#    "${tmp_parse_file}" \
#    "${training_dir}/cv.dev.sentences.turboparsed.standard.stanford.all.lemma.tags"
#rm "${tmp_parse_file}"
