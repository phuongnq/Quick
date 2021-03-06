//
//  FunctionalTests.swift
//  QuickTests
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import Quick

class PersonSpec: QuickSpec {
    override func exampleGroups() {
        describe("Person") {
            var person: Person! = nil
            var dinosaursExtinct = false
            var mankindExtinct = false

            beforeSuite {
                assert(!dinosaursExtinct, "nothing goes extinct twice")
                dinosaursExtinct = true
            }

            afterSuite {
                assert(!mankindExtinct, "tests shouldn't run after the apocalypse")
                mankindExtinct = true
            }

            beforeEach { person = Person() }
            afterEach  { person = nil }

            it("is happy") {
                expect(person.isHappy).to.beTrue()
            }

            it("is a dreamer") {
                expect(person.hopes).to.contain("winning the lottery")
            }

            it("gets hungry") {
                person!.eatChineseFood()
                expect{person.isHungry}.will.beTrue()
            }

            it("will never be satisfied") {
                expect{person.isSatisfied}.willNot.beTrue()
            }

            it("🔥🔥それでも俺たちは🔥🔥") {
                expect{person.isSatisfied}.willNot.beTrue()
            }

            pending("but one day") {
                it("will never want for anything") {
                    expect{person.isSatisfied}.will.beTrue()
                }
            }

            it("does not live with dinosaurs") {
                expect(dinosaursExtinct).to.beTrue()
                expect(mankindExtinct).toNot.beTrue()
            }

            describe("greeting") {
                context("when the person is unhappy") {
                    beforeEach { person.isHappy = false }
                    it("is lukewarm") {
                        expect(person.greeting).to.equal("Oh, hi.")
                        expect(person.greeting).toNot.equal("Hello!")
                    }
                }

                context("when the person is happy") {
                    beforeEach { person!.isHappy = true }
                    it("is enthusiastic") {
                        expect(person.greeting).to.equal("Hello!")
                        expect(person.greeting).toNot.equal("Oh, hi.")
                    }
                }
            }
        }
    }
}

class PoetSpec: QuickSpec {
    override func exampleGroups() {
        describe("Poet") {
            // FIXME: Radar worthy? `var poet: Poet?` results in build error:
            //        "Could not find member 'greeting'"
            var poet: Person! = nil
            beforeEach { poet = Poet() }

            describe("greeting") {
                context("when the poet is unhappy") {
                    beforeEach { poet.isHappy = false }
                    it("is dramatic") {
                        expect(poet.greeting).to.equal("Woe is me!")
                    }
                }

                context("when the poet is happy") {
                    beforeEach { poet.isHappy = true }
                    it("is joyous") {
                        expect(poet.greeting).to.equal("Oh, joyous day!")
                    }
                }
            }
        }
    }
}

class UnhandledExceptionSpec: QuickSpec {

    var expected = NSException(name: "name", reason: "reason", userInfo: nil)
    let exampleCallsite = Callsite(file: "file", line: -1)

    override func exampleGroups() {

        describe("unexpected exceptions raised during an example") {
            it("catches unhandled exceptions", {
                self.expected.raise()
                XCTFail("expected test execution not to continue after raised exception")
            }, file: self.exampleCallsite.file, line: self.exampleCallsite.line)
        }

    }

    override func example(example: Example!, failedWithException actualException: NSException!) {
        let actualCallsite = example.callsite
        expect(actualCallsite.file).to.equal(exampleCallsite.file)
        expect(actualCallsite.line).to.equal(exampleCallsite.line)
        expect(actualException).to.equal(expected)
    }

}
