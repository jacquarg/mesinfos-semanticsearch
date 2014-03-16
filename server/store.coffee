store = null
rdfstore = require './rdfstore'

module.exports.init = (cb) ->
    rdfstore.create {persistent:true, name:'myappstore'}, (created) ->
        store = created
        store.setPrefix 'my', 'https://my.cozy.io/'
        store.setPrefix 'pdta', 'http://www.techtane.info/personaldata.ttl#'
        store.setPrefix 'pcrd', 'http://www.techtane.info/phonecommunicationlog.ttl#'
        store.setPrefix 'time', 'http://www.w3.org/2006/time#'
        cb()

module.exports.modelName = (model) -> "my:#{model._id}"

makeNode = (x) ->
    store.rdf.createNamedNode x
module.exports.makeTriple = makeTriple = (o, v, c) ->
    o = makeNode(o) if typeof o is "string"
    v = makeNode(v) if typeof v is "string"
    c = makeNode(c) if typeof c is "string"
    store.rdf.createTriple o, v, c

module.exports.newGraph = () -> store.rdf.createGraph()
module.exports.insert = (graph, cb) -> store.insert graph, cb

module.exports.addDuration = (graph, model, units, count) ->
    name = module.exports.modelName model
    graph.add makeTriple name, "hasDuration", "#{name}.duration"
    graph.add makeTriple "#{name}.duration", "a", "time:DurationDescription"
    graph.add makeTriple "#{name}.duration", "time:#{units}", count

module.exports.addDatetime = (graph, model, date) ->
    name = module.exports.modelName model
    graph.add makeTriple name, "time:hasInstant", "#{name}.begin"
    graph.add makeTriple "#{name}.begin", "a", "time:Instant"
    graph.add makeTriple "#{name}.begin", "time:inDateTime", "#{name}.begindtd"
    graph.add makeTriple "#{name}.begindtd", "time:unitType", "time:unitSecond"
    graph.add makeTriple "#{name}.begindtd", "time:year", store.rdf.createLiteral date.getYear()
    graph.add makeTriple "#{name}.begindtd", "time:month", store.rdf.createLiteral date.getMonth()
    graph.add makeTriple "#{name}.begindtd", "time:day", store.rdf.createLiteral date.getDate()
    graph.add makeTriple "#{name}.begindtd", "time:hour", store.rdf.createLiteral date.getHours()
    graph.add makeTriple "#{name}.begindtd", "time:minute", store.rdf.createLiteral date.getMinutes()
    graph.add makeTriple "#{name}.begindtd", "time:second", store.rdf.createLiteral date.getSeconds()