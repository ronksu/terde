define ['lodash', 'knockout','../scripts/TerracePager'], (_, ko, TerracePager) ->
  testData = false

  generatePointFunctor = (prefix) ->
    (accu, value, key) ->
      accu.push
        name: "#{prefix}#{key}"
        address: "#{prefix}#{key}address"
      accu

  beforeEach ->
    testData = ko.observable(_.reduce [0..21], generatePointFunctor('data'), [])

  expectPageData = (data, span) ->
    expect(data).to.be.a('Array').and.to.have.length(span.length)
    for i in span
      do (i) ->
        expect(data[i - span[0]].name).to.be.a('String').and.to.equal("data#{i}")
        expect(data[i - span[0]].address).to.be.a('String').and.to.equal("data#{i}address")

  describe "Terrace pager", ->
    it "returns 1st page on init", ->
      pager = new TerracePager({results: testData})
      expectPageData(pager.pageData(), [0..4])
      expect(pager.visible()).to.equal(true)
      expect(pager.previousDisabled()).to.equal(true)
      expect(pager.nextDisabled()).to.equal(false)

    it "is not visible if less than 5 results", ->
      pager = new TerracePager({results: ko.observable([1..4])})
      expect(pager.pageData()).to.be.a('Array').and.to.have.length(4)
      expect(pager.visible()).to.equal(false)

    it "does nothing on 1st/last page if page changed", ->
      pager = new TerracePager({results: ko.observable([1..4])})
      expect(pager.pageData()).to.be.a('Array').and.to.have.length(4)
      expect(pager.previousDisabled()).to.equal(true)
      expect(pager.nextDisabled()).to.equal(true)

      pager.previous()
      expect(pager.pageData()).to.be.a('Array').and.to.have.length(4)
      expect(pager.previousDisabled()).to.equal(true)
      expect(pager.nextDisabled()).to.equal(true)

      pager.next()
      expect(pager.pageData()).to.be.a('Array').and.to.have.length(4)
      expect(pager.previousDisabled()).to.equal(true)
      expect(pager.nextDisabled()).to.equal(true)

    it "returns correct data on page change", ->
      pager = new TerracePager({results: testData})
      expectPageData(pager.pageData(), [0..4])
      expect(pager.visible()).to.equal(true)
      expect(pager.previousDisabled()).to.equal(true)
      expect(pager.nextDisabled()).to.equal(false)

      # OOB
      pager.previous()
      expectPageData(pager.pageData(), [0..4])
      expect(pager.visible()).to.equal(true)
      expect(pager.previousDisabled()).to.equal(true)
      expect(pager.nextDisabled()).to.equal(false)

      # page 2
      pager.next()
      expectPageData(pager.pageData(), [5..9])
      expect(pager.visible()).to.equal(true)
      expect(pager.previousDisabled()).to.equal(false)
      expect(pager.nextDisabled()).to.equal(false)

      # back to first
      pager.previous()
      expectPageData(pager.pageData(), [0..4])
      expect(pager.visible()).to.equal(true)
      expect(pager.previousDisabled()).to.equal(true)
      expect(pager.nextDisabled()).to.equal(false)

      # page 2
      pager.next()
      expectPageData(pager.pageData(), [5..9])
      expect(pager.visible()).to.equal(true)
      expect(pager.previousDisabled()).to.equal(false)
      expect(pager.nextDisabled()).to.equal(false)

      # page 3
      pager.next()
      expectPageData(pager.pageData(), [10..14])
      expect(pager.visible()).to.equal(true)
      expect(pager.previousDisabled()).to.equal(false)
      expect(pager.nextDisabled()).to.equal(false)

      # page 4
      pager.next()
      expectPageData(pager.pageData(), [15..19])
      expect(pager.visible()).to.equal(true)
      expect(pager.previousDisabled()).to.equal(false)
      expect(pager.nextDisabled()).to.equal(false)

      # page 5
      pager.next()
      expectPageData(pager.pageData(), [20..21])
      expect(pager.visible()).to.equal(true)
      expect(pager.previousDisabled()).to.equal(false)
      expect(pager.nextDisabled()).to.equal(true)

      # OOB
      pager.next()
      expectPageData(pager.pageData(), [20..21])
      expect(pager.visible()).to.equal(true)
      expect(pager.previousDisabled()).to.equal(false)
      expect(pager.nextDisabled()).to.equal(true)

      # page 4
      pager.previous()
      expectPageData(pager.pageData(), [15..19])
      expect(pager.visible()).to.equal(true)
      expect(pager.previousDisabled()).to.equal(false)
      expect(pager.nextDisabled()).to.equal(false)
