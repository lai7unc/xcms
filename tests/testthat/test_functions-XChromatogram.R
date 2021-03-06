test_that(".validXChromatogram works", {
    xc <- new("XChromatogram")
    expect_true(.validXChromatogram(xc))
    xc@chromPeaks <- matrix(1:10, ncol = 5)
    expect_true(is.character(.validXChromatogram(xc)))
    mat <- matrix("A", ncol = 6, nrow = 2)
    xc@chromPeaks <- mat
    expect_true(is.character(.validXChromatogram(xc)))
    mat <- matrix(ncol = 6, nrow = 2)
    colnames(mat) <- .CHROMPEAKS_REQ_NAMES
    mat[, "rtmin"] <- c(3, 3)
    mat[, "rtmax"] <- c(3, 4)
    xc@chromPeaks <- mat
    expect_true(is.character(.validXChromatogram(xc)))
    xc@chromPeakData <- DataFrame(ms_level = c(1L, 1L), is_filled = FALSE)
    expect_true(.validXChromatogram(xc))
    xc@chromPeakData <- DataFrame(ms_level = 1L, is_filled = TRUE)
    expect_true(is.character(.validXChromatogram(xc)))
    xc@chromPeakData <- DataFrame(ms_level = c(1L, 1L), other = "a")
    expect_true(is.character(.validXChromatogram(xc)))
    xc@chromPeaks[, "rtmin"] <- c(4, 3)
    expect_true(is.character(.validXChromatogram(xc)))
})

test_that("XChromatogram works", {
    xc <- XChromatogram(rtime = 1:10, intensity = 1:10)
    expect_true(nrow(xc@chromPeaks) == 0)
    expect_true(nrow(xc@chromPeakData) == 0)
    expect_equal(rtime(xc), 1:10)
    expect_true(validObject(xc))

    xc <- XChromatogram()
    expect_true(nrow(xc@chromPeaks) == 0)
    expect_true(nrow(xc@chromPeakData) == 0)
    expect_error(XChromatogram(chr, 4))
    expect_true(validObject(xc))

    pks <- matrix(nrow = 2, ncol = length(.CHROMPEAKS_REQ_NAMES),
                  dimnames = list(character(), .CHROMPEAKS_REQ_NAMES))
    pks[, "rtmin"] <- c(2, 4)
    pks[, "rtmax"] <- c(3, 5)
    xc <- XChromatogram(rtime = 1:10, intensity = 1:10, chromPeaks = pks)
    expect_equal(xc@chromPeaks[, "rtmin"], c(2, 4))
    expect_true(validObject(xc))
    expect_true(is.logical(xc@chromPeakData$is_filled))
    expect_true(is.integer(xc@chromPeakData$ms_level))
    expect_equal(xc@chromPeakData$ms_level, c(1L, 1L))

    df <- DataFrame(ms_level = c(1L, 2L))
    xc <- XChromatogram(rtime = 1:10, intensity = 1:10, chromPeaks = pks,
                        chromPeakData = df)
    expect_true(validObject(xc))
    expect_equal(xc@chromPeakData$ms_level, c(1L, 2L))
})

test_that(".add_chromatogram_peaks works", {
    xc <- XChromatogram(rtime = 1:10, intensity = c(2, 5, 12, 32, 38, 21, 13,
                                                    5, 5, 9))
    plot(xc)
    pks <- matrix(c(5, 3, 7, NA, 38, NA), nrow = 1,
                  dimnames = list(character(), c("rt", "rtmin", "rtmax",
                                                 "into", "maxo", "sn")))
    .add_chromatogram_peaks(xc, pks, type = "point", pch = 16,
                                   col = "red", bg = "black")
    .add_chromatogram_peaks(xc, pks, type = "rectangle", pch = 16,
                                   col = "red", bg = NA)
    .add_chromatogram_peaks(xc, pks, type = "polygon", col = "#00ff0020",
                                   bg = "#00ff0060")
})
