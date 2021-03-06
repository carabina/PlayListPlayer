//
//  PlayListPlayerSpec.swift
//  PlayListPlayer
//
//  Created by Kohei Tabata on 2016/08/02.
//  Copyright © 2016年 nerd0geek1. All rights reserved.
//

import AVFoundation
import Quick
import Nimble

class PlayListPlayerSpec: QuickSpec {
    override func spec() {
        describe("PlayListPlayer") {
            describe("setPlayList(urls: [NSURL])", {
                it("will update playListURLs", closure: {
                    let urls: [NSURL] = [
                        FileHelper.audio1URL(),
                        FileHelper.audio2URL(),
                        FileHelper.movie1URL()]

                    let player: PlayListPlayer = PlayListPlayer()

                    player.setPlayList(urls)

                    expect(player.hasPlayList()).to(beTrue())
                    expect(player.playListURLs).to(equal(urls))
                })
            })
            describe("setCurrentIndex(index: Int)", {
                let urls: [NSURL] = [
                    FileHelper.audio1URL(),
                    FileHelper.audio2URL(),
                    FileHelper.movie1URL()]

                context("when index is within playList index range", {
                    it("will return true, update current index", closure: {
                        let player: PlayListPlayer = PlayListPlayer()
                        player.setPlayList(urls)

                        expect(player.currentIndex).to(equal(0))

                        let index: Int   = 2
                        let result: Bool = player.setCurrentIndex(index)

                        expect(result).to(beTrue())
                        expect(player.currentIndex).to(equal(index))
                    })
                })
                context("when index is beyond playList index range", {
                    it("will return false, don't update current index", closure: {
                        let player: PlayListPlayer = PlayListPlayer()
                        player.setPlayList(urls)

                        expect(player.currentIndex).to(equal(0))

                        let result: Bool = player.setCurrentIndex(3)

                        expect(result).to(beFalse())
                        expect(player.currentIndex).to(equal(0))
                    })
                })
            })

            describe("engine()", {
                it("will return AVPlayer instance", closure: {
                    let player: PlayListPlayer = PlayListPlayer()

                    expect(player.engine().currentItem).to(beNil())
                    expect(player.engine().rate).to(equal(0.0))
                })
            })

            describe("hasPlayList()", {
                context("when playList was set", {
                    it("will return true", closure: {
                        let urls: [NSURL] = [
                            FileHelper.audio1URL(),
                            FileHelper.audio2URL(),
                            FileHelper.movie1URL()]
                        let player: PlayListPlayer = PlayListPlayer()

                        player.setPlayList(urls)

                        expect(player.hasPlayList()).to(beTrue())
                    })
                })
                context("when playList wasn't set", {
                    it("will return false", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        expect(player.hasPlayList()).to(beFalse())
                    })
                })
            })

            describe("currentTrackURL()", {
                context("playList was set", {
                    it("will return current track url", closure: {
                        let urls: [NSURL] = [
                            FileHelper.audio1URL(),
                            FileHelper.audio2URL(),
                            FileHelper.movie1URL()]
                        let player: PlayListPlayer = PlayListPlayer()

                        player.setPlayList(urls)

                        expect(player.currentTrackURL()).to(equal(FileHelper.audio1URL()))
                    })
                })
                context("playList wasn't set", {
                    it("will return nil", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        expect(player.currentTrackURL()).to(beNil())
                    })
                })
            })

            describe("isPlaying()", {
                context("when playList is empty", {
                    it("will return false", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        expect(player.isPlaying()).to(beFalse())
                    })
                })

                context("when playList was set", {
                    it("will return false", closure: {
                        let urls: [NSURL] = [
                            FileHelper.audio1URL(),
                            FileHelper.audio2URL(),
                            FileHelper.movie1URL()]
                        let player: PlayListPlayer = PlayListPlayer()

                        player.setPlayList(urls)

                        expect(player.isPlaying()).to(beFalse())
                    })
                })
                context("when playList was set and called play()", {
                    it("will return true", closure: {
                        let urls: [NSURL] = [
                            FileHelper.audio1URL(),
                            FileHelper.audio2URL(),
                            FileHelper.movie1URL()]
                        let player: PlayListPlayer = PlayListPlayer()

                        player.setPlayList(urls)
                        player.play()

                        expect(player.isPlaying()).to(beTrue())
                    })
                })
                context("when playList was set and called beginFastForwarding()", {
                    it("will return true", closure: {
                        let urls: [NSURL] = [
                            FileHelper.audio1URL(),
                            FileHelper.audio2URL(),
                            FileHelper.movie1URL()]
                        let player: PlayListPlayer = PlayListPlayer()

                        player.setPlayList(urls)
                        player.beginFastForwarding()

                        expect(player.isPlaying()).to(beTrue())
                    })
                })
                context("when playList was set and called pause()", {
                    it("will return false", closure: {
                        let urls: [NSURL] = [
                            FileHelper.audio1URL(),
                            FileHelper.audio2URL(),
                            FileHelper.movie1URL()]
                        let player: PlayListPlayer = PlayListPlayer()

                        player.setPlayList(urls)
                        player.play()
                        player.pause()

                        expect(player.isPlaying()).to(beFalse())
                    })
                })
                context("when playList was set and called beginRewinding()", {
                    it("will return true", closure: {
                        let urls: [NSURL] = [
                            FileHelper.audio1URL(),
                            FileHelper.audio2URL(),
                            FileHelper.movie1URL()]
                        let player: PlayListPlayer = PlayListPlayer()

                        player.setPlayList(urls)
                        player.beginRewinding()

                        expect(player.isPlaying()).to(beTrue())
                    })
                })
            })

            describe("play()", {
                context("when playList was set", {
                    it("will make rate 1.0, currentTrackURL() audio1URL()", closure: {
                        let urls: [NSURL] = [
                            FileHelper.audio1URL(),
                            FileHelper.audio2URL(),
                            FileHelper.movie1URL()]
                        let player: PlayListPlayer = PlayListPlayer()

                        player.setPlayList(urls)
                        player.play()

                        expect(player.engine().rate).to(equal(1.0))
                        expect(player.currentTrackURL()).to(equal(FileHelper.audio1URL()))
                    })
                })
                context("when playList wasn't set", {
                    it("will not cause crash", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        player.play()

                        expect(player.isPlaying()).to(beFalse())
                    })
                })

            })
            describe("pause()", {
                context("when playList was set", {
                    it("will make rate 0.0, currentTrackURL() audio1URL()", closure: {
                        let urls: [NSURL] = [
                            FileHelper.audio1URL(),
                            FileHelper.audio2URL(),
                            FileHelper.movie1URL()]
                        let player: PlayListPlayer = PlayListPlayer()

                        player.setPlayList(urls)
                        player.play()
                        expect(player.engine().rate).to(equal(1.0))
                        player.pause()

                        expect(player.engine().rate).to(equal(0.0))
                        expect(player.currentTrackURL()).to(equal(FileHelper.audio1URL()))
                    })
                })
                context("when playList wasn't set", {
                    it("will not cause crash", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        player.pause()

                        expect(player.isPlaying()).to(beFalse())
                    })
                })
            })
            describe("beginFastForwarding()", {
                context("when playList was set", {
                    it("will make rate 2.0, currentTrackURL() audio1URL()", closure: {
                        let urls: [NSURL] = [
                            FileHelper.audio1URL(),
                            FileHelper.audio2URL(),
                            FileHelper.movie1URL()]
                        let player: PlayListPlayer = PlayListPlayer()

                        player.setPlayList(urls)
                        player.beginFastForwarding()

                        expect(player.engine().rate).to(equal(2.0))
                        expect(player.currentTrackURL()).to(equal(FileHelper.audio1URL()))
                    })
                })
                context("when playList wasn't set", {
                    it("will not cause crash", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        player.beginFastForwarding()

                        expect(player.isPlaying()).to(beFalse())
                    })
                })
            })
            describe("endFastForwarding()", {
                context("when playList was set", {
                    it("will make rate 1.0, currentTrackURL() audio1URL()", closure: {
                        let urls: [NSURL] = [
                            FileHelper.audio1URL(),
                            FileHelper.audio2URL(),
                            FileHelper.movie1URL()]
                        let player: PlayListPlayer = PlayListPlayer()

                        player.setPlayList(urls)
                        player.endFastForwarding()

                        expect(player.engine().rate).to(equal(1.0))
                        expect(player.currentTrackURL()).to(equal(FileHelper.audio1URL()))
                    })
                })
                context("when playList wasn't set", {
                    it("will not cause crash", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        player.endFastForwarding()

                        expect(player.isPlaying()).to(beFalse())
                    })
                })
            })
            describe("skipToNextTrack()", {
                context("when playList was set", {
                    context("and currentIndex is last index", {
                        it("will play next track", closure: {
                            let urls: [NSURL] = [
                                FileHelper.audio1URL(),
                                FileHelper.audio2URL(),
                                FileHelper.movie1URL()]
                            let player: PlayListPlayer = PlayListPlayer()

                            player.setPlayList(urls)
                            player.skipToNextTrack()

                            expect(player.isPlaying()).to(beTrue())
                            expect(player.currentIndex).to(equal(1))
                            expect(player.currentTrackURL()).to(equal(FileHelper.audio2URL()))
                        })
                    })
                    context("and currentIndex is not last index", {
                        it("will pause at current track", closure: {
                            let urls: [NSURL] = [
                                FileHelper.audio1URL(),
                                FileHelper.audio2URL(),
                                FileHelper.movie1URL()]
                            let player: PlayListPlayer = PlayListPlayer()

                            player.setPlayList(urls)
                            player.setCurrentIndex(2)
                            player.skipToNextTrack()

                            expect(player.isPlaying()).to(beFalse())
                            expect(player.currentIndex).to(equal(2))
                            expect(player.engine().currentTime()).to(equal(kCMTimeZero))
                            expect(player.currentTrackURL()).to(equal(FileHelper.movie1URL()))
                        })
                    })
                })
                context("when playList wasn't set", {
                    it("will not cause crash", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        player.skipToNextTrack()

                        expect(player.isPlaying()).to(beFalse())
                    })
                })
            })
            describe("beginRewinding()", {
                context("when playList was set", {
                    it("will make rate -2.0, currentTrackURL() audio1URL()", closure: {
                        let urls: [NSURL] = [
                            FileHelper.audio1URL(),
                            FileHelper.audio2URL(),
                            FileHelper.movie1URL()]
                        let player: PlayListPlayer = PlayListPlayer()

                        player.setPlayList(urls)
                        player.beginRewinding()

                        expect(player.engine().rate).to(equal(-2.0))
                        expect(player.currentTrackURL()).to(equal(FileHelper.audio1URL()))
                    })
                })
                context("when playList wasn't set", {
                    it("will not cause crash", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        player.beginRewinding()

                        expect(player.isPlaying()).to(beFalse())
                    })
                })
            })
            describe("endRewinding()", {
                context("when playList was set", {
                    it("will make rate 1.0, currentTrackURL() audio1URL()", closure: {
                        let urls: [NSURL] = [
                            FileHelper.audio1URL(),
                            FileHelper.audio2URL(),
                            FileHelper.movie1URL()]
                        let player: PlayListPlayer = PlayListPlayer()

                        player.setPlayList(urls)
                        player.endRewinding()

                        expect(player.engine().rate).to(equal(1.0))
                        expect(player.currentTrackURL()).to(equal(FileHelper.audio1URL()))
                    })
                })
                context("when playList wasn't set", {
                    it("will not cause crash", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        player.endRewinding()

                        expect(player.isPlaying()).to(beFalse())
                    })
                })
            })
            describe("jumpToPreviousTrack()", {
                context("when playList was set", {
                    context("and currentIndex is 0", {
                        it("will play next track", closure: {
                            let urls: [NSURL] = [
                                FileHelper.audio1URL(),
                                FileHelper.audio2URL(),
                                FileHelper.movie1URL()]
                            let player: PlayListPlayer = PlayListPlayer()

                            player.setPlayList(urls)
                            player.jumpToPreviousTrack()

                            expect(player.isPlaying()).to(beTrue())
                            expect(player.currentIndex).to(equal(0))
                            expect(player.currentTrackURL()).to(equal(FileHelper.audio1URL()))
                        })
                    })
                    context("and currentIndex is not 0", {
                        it("will pause at current track", closure: {
                            let urls: [NSURL] = [
                                FileHelper.audio1URL(),
                                FileHelper.audio2URL(),
                                FileHelper.movie1URL()]
                            let player: PlayListPlayer = PlayListPlayer()

                            player.setPlayList(urls)
                            player.setCurrentIndex(2)
                            player.jumpToPreviousTrack()

                            expect(player.isPlaying()).to(beTrue())
                            expect(player.currentIndex).to(equal(1))
                            expect(player.engine().currentTime()).to(equal(kCMTimeZero))
                            expect(player.currentTrackURL()).to(equal(FileHelper.audio2URL()))
                        })
                    })
                })
                context("when playList wasn't set", {
                    it("will not cause crash", closure: {
                        let player: PlayListPlayer = PlayListPlayer()

                        player.jumpToPreviousTrack()
                        
                        expect(player.isPlaying()).to(beFalse())
                    })
                })
            })
        }
    }
}
