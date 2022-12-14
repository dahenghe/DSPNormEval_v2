#' Evaluate Performance of Normlaization Methods by Comparing Technical Variation among Replicates
#' @description The function generates distribution plots of normalized DSP data of the ROIs that are treated as biological replicates by a list of normalization methods. A better normalization method is expected to yield smaller technical variations among biological replicates.
#' @return ggplot2 object of distribution plot.
#' @details To add some details here!
#' @export
#' @import graphics stats ggplot2
#' @param normed.data.list a list object containing the normalized DSP expression matrix under all normalization methods, each normalized matrix can be either a data.frame or matrix.
#' @param norm.methods.list a numerical vector of the method IDs to be compared, for instance, norm.methods.list = 1:17.
#' @param grouping.info a character vector describing grouping info of each ROI, must be arranged in the same order of the columns of DSP expression matrix.
#' @param main title to be added to the output figure.
#' @param title.size font size of title.
#' @param deviation.from.median if TRUE, the distribution of expressions of proteins within each ROI is evaluated relative to its median.
#' @param group.focus a character vector specifying which group in \code{"grouping.info"} is to be collected for distribution plot, the ROIs in the selected group is to be treated as biological replicates.
#' @param range.universal a numerical vector of length two, specifying the range of distribution to be plotted. If unspecified, then the range is decided automatically by the actual range of input data.
norm.eval.tech.var <- function(normed.data.list, norm.methods.list, grouping.info, main="", title.size=6, deviation.from.median=F, group.focus="treatment", range.universal=c(NA, NA)){

  # library(ggplot2)
  # library("ggfortify")
  # library(gridExtra)


  plots.list = list()
  plot_id = 1


  # collect distribution plots for all normalization methos on the same page:
  grp.uniq = group.focus

  for (grp_id in 1:length(grp.uniq)) {

    for (method_id in norm.methods.list) {

      data.scaled.bg_corrected.normed.pt.i = normed.data.list[[method_id]]

      for.densityplot = data.scaled.bg_corrected.normed.pt.i[ ,grouping.info==grp.uniq[grp_id]]



      for.densityplot.long = data.frame(Expr.Norm=for.densityplot[ ,1])
      if(deviation.from.median){
        for.densityplot.long = data.frame(Expr.Norm=(for.densityplot[ ,1] - median(as.numeric(for.densityplot[ ,1]))))
      }
      for.densityplot.long$ROI = colnames(for.densityplot)[1]

      for (col_id in 2:ncol(for.densityplot)) {
        for.densityplot.long.temp = data.frame(Expr.Norm=for.densityplot[ ,col_id])
        if(deviation.from.median){
          for.densityplot.long.temp = data.frame(Expr.Norm=(for.densityplot[ ,col_id] - median(as.numeric(for.densityplot[ ,col_id]))))
        }
        for.densityplot.long.temp$ROI = colnames(for.densityplot)[col_id]

        for.densityplot.long = rbind(for.densityplot.long, for.densityplot.long.temp)

      }

      myplot.keep = ggplot2::ggplot(for.densityplot.long, aes(Expr.Norm, fill = ROI))
      myplot.keep = myplot.keep + ggplot2::geom_density(alpha = 0.5)
      if(!is.na(range.universal[1])){
        myplot.keep = myplot.keep + ggplot2::xlim(range.universal[1], range.universal[2])
      }
      myplot.keep = myplot.keep + ggplot2::theme(axis.text=ggplot2::element_text(size=5),axis.title=ggplot2::element_text(size=5), plot.title = ggplot2::element_text(size=title.size, face = "bold"), legend.position = "none", panel.grid.minor = ggplot2::element_blank(), panel.background = ggplot2::element_blank(), axis.line = ggplot2::element_line(colour = "black"))
      if(main==""){
        myplot.keep = myplot.keep + ggplot2::ggtitle(paste(method_id, ", ", grp.uniq[grp_id], sep = ""))
      } else{
        #myplot.keep = myplot.keep + ggtitle(paste(main, ", ", method_id, ", ", grp.uniq[grp_id], sep = ""))
        myplot.keep = myplot.keep + ggplot2::ggtitle(paste(main, " ", method_id, sep = ""))
      }

      plots.list[[plot_id]] = myplot.keep
      plot_id = plot_id + 1

    }


  }



return(plots.list)
}











