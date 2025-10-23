// MatraMagica flavored MatraScript Grammar
// ==========================
//
// Accepts expressions like "p`Hello, world!`" and computes their value.

Package
  = docType:"<!DOCTYPE html>"? _ block:Block _ { return block }

Block
  = TagApply
  / TagBody
  / Tag
  / SetRule
  / HtmlElement
  / StringNode
  / CommentNode

Tag
  = _ tag:Slug _ {
    return { tag, properties: {}, children: [] }
  }

TagApply
  = tag:Identifier _ "(" _ args:ArgList? _ ")" {
      let props = null, body = []
      if (args?.length) {
        if (args[0]?.__kind === "bare-object") {
          props = args[0].value
          body = args.slice(1)
        } else {
          body = args
        }
      }
      return {
        type: "element",
        tagName: tag,
        properties: props || {},
        children: body.map(v =>
          typeof v === "string"
            ? { type: "text", value: v }
            : v
        )
      }
    }

ArgList
  = head:Arg tail:(_ "," _ Arg)* { return [head, ...tail.map(t => t[3])] }

Arg
  = BareObject
  / TagApply
  / StringLiteral
  / Number
  / Boolean
  / Identifier

BareObject
  = "{" _ pairs:(BarePair (_ "," _ BarePair)*)? _ "}" {
      if (!pairs) return { __kind:"bare-object", value:{} }
      const xs = [pairs[0], ...(pairs[1] ? pairs[1].map(t => t[3]) : [])]
      return { __kind:"bare-object", value:Object.fromEntries(xs) }
    }

BarePair
  = key:(Identifier / StringLiteral) _ ":" _ val:(StringLiteral / Number / Boolean / Identifier) {
      const k = typeof key === "string" ? key.replace(/^\"|\"$/g, "") : key
      const v = typeof val === "string" && val.startsWith('"') ? val.slice(1, -1) : val
      return [k, v]
    }

StringLiteral
  = "\"" str:([^\"]*) "\"" {
    return str.join("")
  }

Number
  = digits:[0-9]+ ("." [0-9]+)? {
    return parseFloat(text())
  }

Boolean
  = "true" { return true }
  / "false" { return false }

Identifier
  = !ReservedWord first:[a-zA-Z_] rest:[a-zA-Z0-9_\-]* {
    return first + rest.join("")
  }

ReservedWord
  = ("true" / "false") ![a-zA-Z0-9_\-]

TagBody
  = "$root" _ body:Body? {
    return {
      type: "root",
      children: body ?? [],
    }
  }
  / _ tagName:Slug classList:("." @Slug)* id:("#" @Slug)? setRuleArr:("[" @SetRule+ "]")? _ body:Body? {
    return {
      type: "element",
      tagName,
      properties: Object.assign(
        {},
        setRuleArr ? Object.fromEntries(setRuleArr) : {},
        id ? { id } : {},
        classList.length > 0 ? { class: classList.join(" ") } : {}
      ),
      children: body ?? [],
    }
  }

Body
  = "{" _ @Expression _ "}"
  / "{" _ node:StringNode _ "}" { return [node] }

Expression
  = Array
  / block:Block { return [block] }
  / _

Array
  = arr:(Block _)+ {
    return arr.map(item => item[0])
  }

SetRule
  = _ key:Slug _ "=" _ val:String _ {
    return [key, val]
  }

StringNode
  = "\"" str:([^\"]*) "\"" {
    return { type: "text", value: str.join("") }
  }

CommentNode
  = "<!--" _ strMatch:((!("-->") .)*) _ "-->" {
    return {
      type: "comment",
      value: strMatch.map(item => item[1]).join("")
    }
  }

Template
  = Slug

Slug
  = str:[^\'\"\(\)\[\]\{\}\<\>\=\|\#\.\`\n]+ {
    return str.join("").trim()
  }

HtmlElement
  = tagProp:HtmlTagOpen children:HtmlContent* HtmlTagClose _ {
    return {
      type: "element",
      ...tagProp,
      children,
    }
  }
  / tagProp:HtmlTagSelfClose _ {
    return {
      type: "element",
      ...tagProp,
    }
  }

HtmlTagOpen
  = "<" tagName:HtmlIdentifier _ prop:HtmlAttributes? ">" {
    return {
      tagName,
      properties: prop ?? {},
    }
  }

HtmlTagSelfClose
  = "<" tagName:HtmlIdentifier _ prop:HtmlAttributes? "/>" {
    return {
      tagName,
      properties: prop ?? {},
    }
  }

HtmlTagClose
  = "</" HtmlIdentifier ">"

HtmlIdentifier
  = str:([a-zA-Z0-9\-]+) {
    return str.join("")
  }

HtmlAttributes
  = attrArr:HtmlAttribute+ {
    return Object.fromEntries(attrArr)
  }

HtmlAttribute
  = key:HtmlIdentifier "=" val:HtmlQuotedString _ {
    return [key, val]
  }
  / key:HtmlIdentifier {
    return [key, true]
  }

HtmlContent = HtmlElement / HtmlText / HtmlComment

HtmlText
  = str:([^<]+) {
    return {
      type: "text",
      value: str.join("")
    }
  }

HtmlComment
  = CommentNode

HtmlQuotedString
  = "\"" str:([^\"]*) "\"" {
    return str.join("")
  }

String
  = "\"" str:[^\"]* "\"" {
    return str.join("")
  }

_ "whitespace"
  = [ \t\n\r]*