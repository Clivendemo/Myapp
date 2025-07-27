import { generateText } from "ai"
import { openai } from "@ai-sdk/openai"
import { type NextRequest, NextResponse } from "next/server"

export async function POST(req: NextRequest) {
  try {
    const { type, syllabus, grade, subject, strandTopic, substrandSubtopic, numberOfStudents, lessonTimeMinutes } =
      await req.json()

    if (!type || !syllabus || !grade || !subject || !strandTopic || !substrandSubtopic) {
      return NextResponse.json({ error: "Missing required parameters for content generation." }, { status: 400 })
    }

    let prompt: string
    let systemMessage: string
    let maxTokens: number

    if (type === "lesson_plan") {
      if (typeof numberOfStudents !== "number" || typeof lessonTimeMinutes !== "number") {
        return NextResponse.json(
          { error: "Missing required parameters for lesson plan generation: numberOfStudents, lessonTimeMinutes." },
          { status: 400 },
        )
      }

      if (syllabus === "CBC") {
        prompt =
          `Generate a detailed CBC lesson plan for Grade ${grade}, Subject: ${subject}, Strand: ${strandTopic}, Substrand: ${substrandSubtopic}. ` +
          `Include: Key Inquiry Question, Core Competencies, Values, PCI links. ` +
          `Structure: Introduction (5 mins), Lesson Development (${lessonTimeMinutes - 10} mins), Conclusion (5 mins). ` +
          `Number of students: ${numberOfStudents}. Lesson time: ${lessonTimeMinutes} minutes. ` +
          `Ensure the plan is comprehensive and suitable for Kenyan education context.` +
          `The output should be a well-formatted text, suitable for direct display.`
      } else {
        // 8-4-4 Syllabus
        prompt =
          `Generate a detailed 8-4-4 lesson plan for Form ${grade}, Subject: ${subject}, Topic: ${strandTopic}, Subtopic: ${substrandSubtopic}. ` +
          `Include: Objectives, Introduction (5 mins), Lesson Development (${lessonTimeMinutes - 10} mins), Conclusion (5 mins). ` +
          `Number of students: ${numberOfStudents}. Lesson time: ${lessonTimeMinutes} minutes. ` +
          `Ensure the plan is comprehensive and suitable for Kenyan education context.` +
          `The output should be a well-formatted text, suitable for direct display.`
      }
      systemMessage =
        "You are a helpful assistant for Kenyan teachers, specializing in generating lesson plans for CBC and 8-4-4 syllabuses."
      maxTokens = 1000
    } else if (type === "notes") {
      if (syllabus === "CBC") {
        prompt =
          `Generate comprehensive notes for Grade ${grade}, Subject: ${subject}, Strand: ${strandTopic}, Substrand: ${substrandSubtopic}, based on the CBC syllabus. ` +
          `Ensure the notes are detailed, accurate, and suitable for Kenyan students.` +
          `The output should be a well-formatted text, suitable for direct display.`
      } else {
        // 8-4-4 Syllabus
        prompt =
          `Generate comprehensive notes for Form ${grade}, Subject: ${subject}, Topic: ${strandTopic}, Subtopic: ${substrandSubtopic}, based on the 8-4-4 syllabus. ` +
          `Ensure the notes are detailed, accurate, and suitable for Kenyan students.` +
          `The output should be a well-formatted text, suitable for direct display.`
      }
      systemMessage =
        "You are a helpful assistant for Kenyan teachers, specializing in generating educational notes for CBC and 8-4-4 syllabuses."
      maxTokens = 1500
    } else {
      return NextResponse.json(
        { error: 'Invalid content type specified. Must be "lesson_plan" or "notes".' },
        { status: 400 },
      )
    }

    const { text } = await generateText({
      model: openai("gpt-4o"), // Using gpt-4o as previously discussed
      prompt: prompt,
      system: systemMessage,
      maxTokens: maxTokens,
      temperature: 0.7,
    })

    if (!text) {
      return NextResponse.json({ error: "OpenAI did not return any content." }, { status: 500 })
    }

    return NextResponse.json({ content: text })
  } catch (error: any) {
    console.error("Error calling OpenAI API:", error)
    return NextResponse.json(
      { error: "Failed to generate content from OpenAI.", details: error.message },
      { status: 500 },
    )
  }
}
