defmodule Crutches.Range do
  @moduledoc ~s"""
  Convenience functions for ranges.
  """

  @doc ~S"""
  Determines if two ranges overlap each other.

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
  Determines if two ranges are contiguos.

  Note that the order of the limits does not matter to determine whether the ranges are contiguous
  or not (eg. `1..3` and `4..6` are contiguos, same as `3..1` and `4..6`).

  If the ranges overlap each other, it will return `false`.

  ## Examples

    iex> Range.contiguous?(1..4, 5..8)
    true

    iex> Range.contiguous?(1..4, 0..-4)
    true

    # Ranges overlap
    iex> Range.contiguous?(1..4, 0..1)
    false

    iex> Range.contiguous?(1..4, 6..8)
    false

    iex> Range.contiguous?(1..5, 4..8)
    false
  """
  @spec contiguous?(Range.t, Range.t) :: boolean
  def contiguous?(range1, range2) do
    a..b = normalize_order(range1)
    x..y = normalize_order(range2)
    if (b + 1 == x) or (y + 1 == a) do
      true
    else
      false
    end
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
  both ranges, provided that the ranges overlap or are contiguous.
  
  Note that the returned range, if any, will be in ascending order.

  ## Examples

      iex> Range.union(1..5, 4..8)
      1..8

      iex> Range.union(-1..8, -3..4)
      -3..8

      iex> Range.union(1..3, 4..6)
      1..6

      iex> Range.union(1..1, 2..2)
      1..2

      iex> Range.union(1..3, 3..6)
      1..6

      iex> Range.union(3..6, 1..3)
      1..6
  """
  @spec union(Range.t, Range.t) :: Range.t | nil
  def union(range1, range2) do
    if overlaps?(range1, range2) or contiguous?(range1, range2) do
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
