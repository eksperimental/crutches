defmodule Crutches.Range do
  @moduledoc ~s"""
  Convenience functions for ranges.
  """

  @doc ~S"""
  Compare two ranges and see if they overlap each other.

  ## Examples

    iex> Range.overlaps?(1..5, 4..6)
    true

    iex> Range.overlaps?(1..5, 7..9)
    false

    iex> Range.overlaps?(-1..-5, -4..-6)
    true

    iex> Range.overlaps?(-1..-5, -7..-9)
    false

    iex> Range.overlaps?(5..1, 6..4)
    true
  """
  @spec overlaps?(Range.t, Range.t) :: boolean
  def overlaps?(a..b = range1, x.._ = range2) do
    (a in range2) or (b in range2) or (x in range1)
  end

  @doc ~S"""
  Returns a range containing the range shared in common between `range1` and
  `range2`.
  Returns `nil` if there is no intersection.

  Note that the returned range, if any, will always be in ascending order (the
  first element is <= the last element).

  ## Examples

      iex> Range.intersection(1..5, 4..8)
      4..5

      iex> Range.intersection(1..4, 4..8)
      4..4

      iex> Range.intersection(-1..4, -3..8)
      -1..4

      iex> Range.intersection(1..5, 6..8)
      nil

      iex> Range.intersection(5..3, 2..4)
      3..4

      iex> Range.intersection(5..5, 5..5)
      5..5
  """
  @spec intersection(Range.t, Range.t) :: Range.t | nil
  def intersection(range1, range2) do
    if overlaps?(range1, range2) do
      a..b = normalize_order(range1)
      x..y = normalize_order(range2)
      max(a, x)..min(b, y)
    else
      nil
    end
  end

  @doc ~S"""
  Returns the union of two ranges, or `nil` if there is no union.

  A union the represented by the smallest element and the biggest integers in
  both ranges, provided that they overlap.
  
  Note that the returned range, if any, will be in ascending order.

  ## Examples

      iex> Range.union(1..5, 4..8)
      1..8

      iex> Range.union(-1..8, -3..4)
      -3..8

      iex> Range.union(1..3, 4..6)
      nil

      iex> Range.union(1..3, 3..6)
      1..6

      iex> Range.union(3..6, 1..3)
      1..6
  """
  @spec union(Range.t, Range.t) :: Range.t | nil
  def union(range1, range2) do
    if overlaps?(range1, range2) do
      a..b = normalize_order(range1)
      x..y = normalize_order(range2)
      min(a, x)..max(b, y)
    else
      nil
    end
  end

  # Private helper function that flips a range's order so that it's ascending.
  @spec normalize_order(Range.t) :: Range.t
  defp normalize_order(first..last) when first > last,
    do: last..first
  defp normalize_order(range),
    do: range
end
