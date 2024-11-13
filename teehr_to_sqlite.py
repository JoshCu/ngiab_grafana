import pandas as pd
import sqlite3


def write_to_sqlite(df, table_name, db_path):

    # figure out if x or y is ngen or nwm
    x = df["secondary_location_id_x"].unique()[0].split("-")[0]

    if x.lower() == "ngen":
        df = df.rename(columns={"secondary_value_x": "NGEN", "secondary_value_y": "NWM"})
    else:
        df = df.rename(columns={"secondary_value_x": "NWM", "secondary_value_y": "NGEN"})

    df = df.drop(
        columns=[
            "secondary_location_id_y",
            "unit_name",
            "reference_time_y",
            "reference_time_x",
            "secondary_location_id_x",
            "primary_location_id",
        ]
    )
    df = df.rename(
        columns={
            "value_time": "time",
            "primary_value": "USGS",
        }
    )
    with sqlite3.connect(db_path) as conn:
        df.to_sql(f"{table_name}", conn, if_exists="replace", index=False)


def main():

    df = pd.read_parquet(
        r"/home/josh/raid/work/ngiab_grafana/part-00000-6dac5ff3-e1d2-4ccd-9ecc-bc1c622b2abd.c000.snappy.parquet"
    )
    df2 = pd.read_parquet(
        r"/home/josh/raid/work/ngiab_grafana/part-00001-6dac5ff3-e1d2-4ccd-9ecc-bc1c622b2abd.c000.snappy.parquet"
    )
    # merge the two
    df = pd.merge(df, df2, on=["value_time", "primary_location_id", "primary_value", "unit_name"])

    unique_gages = df["primary_location_id"].unique()

    for gage in unique_gages:
        print(gage)
        df_gage = df[df["primary_location_id"] == gage]
        write_to_sqlite(df_gage, gage, "test.db")


if __name__ == "__main__":
    main()
