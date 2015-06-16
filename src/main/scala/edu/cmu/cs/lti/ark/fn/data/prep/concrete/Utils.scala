package edu.cmu.cs.lti.ark.fn.data.prep.concrete

import edu.jhu.hlt.concrete.Concrete._
import edu.jhu.hlt.concrete.util.IdUtil.generateUUID
import scala.collection.JavaConversions._

object Utils {

  def getAllSentences(communication: Communication): List[Sentence] = {
    communication.getSectionSegmentationList
      .flatMap(_.getSectionList)
      .flatMap(_.getSentenceSegmentationList)
      .flatMap(_.getSentenceList).toList
  }

  def setSentences(communication: Communication, newSentences: Iterable[Sentence]): Communication = {
    val sectionSegmentation = communication.getSectionSegmentation(0)
    val section = sectionSegmentation.getSection(0)
    val newSentenceSegmentation = section.getSentenceSegmentation(0).toBuilder
    newSentences.zipWithIndex.foreach { case (sentence, i) => newSentenceSegmentation.setSentence(i, sentence)}
    val newSection = section.toBuilder.setSentenceSegmentation(0, newSentenceSegmentation.build()).build()
    val newSectionSegmentation = sectionSegmentation.toBuilder.setSection(0, newSection).build()
    communication.toBuilder
      .setUuid(generateUUID())
      .setSectionSegmentation(0, newSectionSegmentation)
      .build()
  }
}
