time :=  /usr/bin/time

all:	count test1k

count:	Makefile
	time stack exec count

noproms:	Makefile
	time stack exec noproms

test100:	Makefile testRnd1kResearch
	diff data/testRnd100Research data/sortedRnd100Research

sortedRnd100kLegalFENs:	Makefile
	time stack exec randomFENs 100 100000 | stack exec sortFENs > data/sortedRnd100kLegalFENs

sortedRnd100kLegalRanks:	Makefile sortedRnd100kLegalFENs
	time stack exec cpr rank < data/sortedRnd100kLegalFENs > data/sortedRnd100kLegalRanks

testRnd100kLegalFENs:	Makefile sortedRnd100kLegalRanks
	time stack cpr unrank < data/sortedRnd100kLegalRanks > data/testRnd100kLegalFEN
	diff data/sortedRnd100kLegalFENs data/testRnd100kLegalFEN

sortedRnd1mLegalFENs:	Makefile
	time stack exec randomFENs 100 1000000 | stack exec sortFENs > data/sortedRnd1mLegalFENs

sortedRnd1mLegalRanks:	Makefile sortedRnd1mLegalFENs
	time stack exec cpr rank < data/sortedRnd1mLegalFENs > data/sortedRnd1mLegalRanks

testRnd1mLegalFENs:	Makefile sortedRnd1mLegalRanks
	time stack exec cpr unrank < data/sortedRnd1mLegalRanks > data/testRnd1mLegalFEN
	diff data/sortedRnd1mLegalFENs data/testRnd1mLegalFEN

testRnd100Ranks:	Makefile
	stack exec randomRs 8726713169886222032347729969256422370854716254 100 | sort -n > data/testRnd100Ranks
	diff data/testRnd100Ranks data/sortedRnd100Ranks

testRnd100FENs:	Makefile testRnd100Ranks
	time stack exec cpr unrank < data/testRnd100Ranks > data/testRnd100FENs
	diff data/testRnd100FENs data/sortedRnd100FENs

testRnd100Research:	Makefile testRnd100FENs
	stack exec legal < data/testRnd100FENs > data/testRnd100Research
	diff data/testRnd100Research data/sortedRnd100Research

testRnd100Ranking:	Makefile testRnd100FENs
	time stack exec cpr rank < data/testRnd100FENs > data/testRnd100FENsRanked
	diff data/testRnd100Ranks data/testRnd100FENsRanked


test1k:	Makefile testRnd1kResearch
	diff data/testRnd1kResearch data/sortedRnd1kResearch

testRnd1kRanks:	Makefile
	stack exec randomRs 8726713169886222032347729969256422370854716254 1000 | sort -n > data/testRnd1kRanks
	diff data/testRnd1kRanks data/sortedRnd1kRanks

testRnd1kFENs:	Makefile testRnd1kRanks
	time stack exec cpr unrank < data/testRnd1kRanks > data/testRnd1kFENs
	diff data/testRnd1kFENs data/sortedRnd1kFENs

testRnd1kResearch:	Makefile testRnd1kFENs
	stack exec legal < data/testRnd1kFENs > data/testRnd1kResearch
	diff data/testRnd1kResearch data/sortedRnd1kResearch

testRnd1kRanking:	Makefile testRnd1kFENs
	time stack exec cpr rank < data/testRnd1kFENs > data/testRnd1kFENsRanked
	diff data/testRnd1kRanks data/testRnd1kFENsRanked


testRnd10kRanks:	Makefile
	stack exec randomRs 8726713169886222032347729969256422370854716254 10000 | sort -n > data/testRnd10kRanks
	diff data/testRnd10kRanks data/sortedRnd10kRanks

testRnd10kFENs:	Makefile testRnd10kRanks
	time stack exec cpr unrank < data/testRnd10kRanks > data/testRnd10kFENs
	diff data/testRnd10kFENs data/sortedRnd10kFENs

testRnd10kResearch:	Makefile testRnd10kFENs
	stack exec legal < data/testRnd10kFENs > data/testRnd10kResearch
	diff data/testRnd10kResearch data/sortedRnd10kResearch


testRnd100kRanks:	Makefile
	stack exec randomRs 8726713169886222032347729969256422370854716254 100000 | sort -n > data/testRnd100kRanks
	diff data/testRnd100kRanks data/sortedRnd100kRanks

testRnd100kRanking:	Makefile testRnd100kFENs
	time stack exec cpr rank < data/testRnd100kFENs > data/testRnd100kFENsRanked
	diff data/testRnd100kRanks data/testRnd100kFENsRanked

testRnd100kFENs:	Makefile testRnd100kRanks
	time stack cpr unrank < data/testRnd100kRanks > data/testRnd100kFENs
	diff data/testRnd100kFENs data/sortedRnd100kFENs

testRnd100kResearch:	Makefile testRnd100kFENs
	stack exec legal < data/testRnd100kFENs > data/testRnd100kResearch
	diff data/testRnd100kResearch data/sortedRnd100kResearch


testRnd1mRanks:	Makefile
	stack exec randomRs 8726713169886222032347729969256422370854716254 1000000 | sort -n > data/testRnd1mRanks
	diff data/testRnd1mRanks data/sortedRnd1mRanks

testRnd1mRanking:	Makefile testRnd1mFENs
	time stack exec cpr rank < data/testRnd1mFENs > data/testRnd1mFENsRanked
	diff data/testRnd1mRanks data/testRnd1mFENsRanked

testRnd1mFENs:	Makefile testRnd1mRanks
	time stack exec cpr unrank < data/testRnd1mRanks > data/testRnd1mFENs
	diff data/testRnd1mFENs data/sortedRnd1mFENs

testRnd1mResearch:	Makefile testRnd1mFENs
	stack exec legal < data/testRnd1mFENs > data/testRnd1mResearch
	diff data/testRnd1mResearch data/sortedRnd1mResearch
