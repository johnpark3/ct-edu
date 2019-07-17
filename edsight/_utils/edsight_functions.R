main_regions <- c("Connecticut", "Fairfield County", "Lower Naugatuck Valley", "Greater Hartford", "Hartford Inner Ring", "Hartford Outer Ring", "Greater New Haven", "New Haven Inner Ring", "New Haven Outer Ring")

main_regions <- c(main_regions, "6 wealthiest Fairfield County", "Greater Waterbury")

regional_dists <- here::here("edsight/_utils/regional_school_dists.tsv") %>%
  read_delim(delim = ";") %>%
  separate_rows(towns, sep = ",") %>%
  mutate(district = str_pad(district, width = 2, side = "left", pad = "0") %>%
           paste("Regional School District", .)) %>%
  rename(town = towns)
region_df <- cwi::regions %>%
  enframe(name = "region", value = "town") %>%
  unnest()
region_df <- region_df %>% 
  dplyr::filter(region %in% main_regions)

region_tmp <- regional_dists %>%
  inner_join(region_df, by = "town") %>%
  select(region, district)

school_dists <- region_df %>%
  rename(district = town) %>%
  bind_rows(region_tmp) %>%
  distinct() %>%
  arrange(region, district)
rm(region_tmp)


region_sum <- function(.data, ..., na.rm = F, drop_flagged = NULL) {
  cols <- quos(...)
  out <- .data
  if (!missing(drop_flagged)) {
    flag_col <- enquo(drop_flagged)
    out <- out %>% 
      filter_at(vars(!!flag_col), magrittr::not)
  }
  out %>%
    inner_join(school_dists, by = "district") %>%
    group_by(region, key, !!!cols) %>%
    summarise_if(is.numeric, sum, na.rm = na.rm) %>%
    ungroup()
}