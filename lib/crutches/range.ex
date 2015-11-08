defmodule Crutches.Range do
  @moduledoc ~s"""
  Convenience functions for ranges.
  """

  @doc """
  Determines if two ranges are congruent (i.e. that both cover the same range, regardless the order
  of their limits).

  ## Examples:

      iex> Range.congruent?(1..5, 5..1)
      true

      iex> Range.congruent?(1..5, 1..5)
      true

      iex> Range.congruent?(1..5, 2..5)
      false
  """
  @spec congruent?(Range.t, Range.t) :: boolean
  def congruent?(range1, range2)
  def congruent?(a..b, x..y) when (a == x and b == y) or (a == y and b == x),
    do: true
  def congruent?(_.._, _.._),
    do: false

  @doc """
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
  def contiguous?(_.._=range1, _.._=range2) do
    a..b = sort(range1)
    x..y = sort(range2)
    if (b + 1 == x) or (y + 1 == a) do
      true
    else
      false
    end
  end

  @doc """
  Returns a range containing the range shared in common between `range1` and
  `range2`.
  Returns `nil` if there is no intersection.

  Note that the returned range, if any, will always be in ascending order (the
  first element is <= the last element).

  ## Examples

      iex> Range.intersection(1..5, 4..8)
      4..5

      iex> Range.intersection(-1..4, -3..8)
      -1..4

      iex> Range.intersection(1..4, 4..8)
      4..4

      iex> Range.intersection(5..5, 5..5)
      5..5

      iex> Range.intersection(1..5, 6..8)
      nil
  """
  @spec intersection(Range.t, Range.t) :: Range.t | nil
  def intersection(range1, range2)
  def intersection(a..b=range1, x..y=_range2) when (a == x and b == y) or (a == y and b == x) do
    sort(range1)
  end

  def intersection(_.._=range1, _.._=range2) do
    if overlaps?(range1, range2) do
      a..b = sort(range1)
      x..y = sort(range2)
      max(a, x)..min(b, y)
    else
      nil
    end
  end

  @doc """
  Determines if two ranges overlap each other.

  ## Examples

      iex> Range.overlaps?(1..5, 4..6)
      true

      iex> Range.overlaps?(1..5, 7..9)
      false

      iex> Range.overlaps?(5..1, 6..4)
      true
  """
  @spec overlaps?(Range.t, Range.t) :: boolean
  def overlaps?(a..b = range1, x.._ = range2) do
    (a in range2) or (b in range2) or (x in range1)
  end

  @doc """
  Swaps the order of the first and last limits in the range.

  ## Examples

    iex> Range.reverse(0..10)
    10..0

    iex> Range.reverse(10..0)
    0..10
  """
  @spec reverse(Range.t) :: Range.t
  def reverse(range)
  def reverse(first..last) do
    last..first
  end

  @doc """
  Sorts the `range` by the given `order`.

  `order` can take either `:ascending` or `:descending`.
  If no `order` is specified, `:ascending` order is used.

  ## Examples

      iex> Range.sort(0..10)
      0..10

      iex> Range.sort(10..0)
      0..10

      iex> Range.sort(0..10, :descending)
      10..0
  """
  @spec sort(Range.t, :ascending | :descending) :: Range.t
  def sort(range, order \\ :ascending)

  def sort(first..last, order)
  when (order == :ascending and first > last) or (order == :descending and last > first) do
    last..first
  end

  def sort(_first.._last=range, order) when order in [:ascending, :descending] do
    range
  end

  @doc """
  Returns the union of two ranges, or `nil` if there is no union.

  A union the represented by the smallest element and the biggest integers in
  both ranges, provided that the ranges overlap or are contiguous.

  Note that the returned range, if any, will be in ascending order.

  ## Examples

      iex> Range.union(1..3, 4..6)
      1..6

      iex> Range.union(1..5, 4..8)
      1..8

      iex> Range.union(3..6, 1..3)
      1..6
  """
  @spec union(Range.t, Range.t) :: Range.t | nil
  def union(range1, range2)
  def union(a..b=range1, x..y=_range2) when (a == x and b == y) or (a == y and b == x) do
    sort(range1)
  end

  def union(_.._=range1, _.._=range2) do
    if overlaps?(range1, range2) or contiguous?(range1, range2) do
      a..b = sort(range1)
      x..y = sort(range2)
      min(a, x)..max(b, y)
    else
      nil
    end
  end
end
